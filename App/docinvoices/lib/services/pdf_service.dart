import 'dart:typed_data';
import '../services/business_profile_repository.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/foundation.dart';
import '../models/job.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
class PdfService {
  static Future<Uint8List> generateInvoice(Job job) async {
    final pdf = pw.Document();

final profile =
    BusinessProfileRepository.instance.profile;

Uint8List? logoBytes;

if (profile.logoPath.trim().isNotEmpty) {
  final directory =
      await getApplicationDocumentsDirectory();

  final fileName = profile.logoPath.contains('/')
      ? Uri.file(profile.logoPath).pathSegments.last
      : profile.logoPath;

  final logoFile = File(
    '${directory.path}/$fileName',
  );

  debugPrint('PDF logo path: ${logoFile.path}');
  debugPrint(
    'PDF logo exists: ${await logoFile.exists()}',
  );

  if (await logoFile.exists()) {
    logoBytes = await logoFile.readAsBytes();
  }
}
final directory =
    await getApplicationDocumentsDirectory();

final List<Uint8List> beforePhotoBytes = [];
final List<Uint8List> afterPhotoBytes = [];

for (final path in job.beforePhotoPaths) {
  final fileName = path.contains('/')
      ? Uri.file(path).pathSegments.last
      : path;

  final file = File(
  '${directory.path}/job_photos/$fileName',
);

  if (await file.exists()) {
    beforePhotoBytes.add(
      await file.readAsBytes(),
    );
  }
}

for (final path in job.afterPhotoPaths) {
  final fileName = path.contains('/')
      ? Uri.file(path).pathSegments.last
      : path;

  final file = File(
  '${directory.path}/job_photos/$fileName',
);

  if (await file.exists()) {
    afterPhotoBytes.add(
      await file.readAsBytes(),
    );
  }
}
    final laborTotal = job.operations.fold<double>(
      0,
      (sum, operation) => sum + operation.laborTotal,
    );

    final partsTotal = job.operations.fold<double>(
      0,
      (sum, operation) => sum + operation.partsTotal,
    );

    final generalChargesTotal = job.generalCharges.fold<double>(
      0,
      (sum, charge) => sum + charge.amount,
    );

    final subtotal = laborTotal + partsTotal + generalChargesTotal;
    final total = subtotal - job.discountAmount;

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.letter,
        margin: const pw.EdgeInsets.all(32),
        build: (context) {
          return [
            _buildHeader(
  job,
  logoBytes,
),
            pw.SizedBox(height: 20),
            _buildCustomerAndEquipment(job),
            pw.SizedBox(height: 20),
            _buildOperations(job),
            if (job.generalCharges.isNotEmpty) ...[
              pw.SizedBox(height: 20),
              _buildGeneralCharges(job),
            ],
            if (beforePhotoBytes.isNotEmpty ||
    afterPhotoBytes.isNotEmpty) ...[
  pw.SizedBox(height: 20),
  _buildJobPhotos(
    beforePhotos: beforePhotoBytes,
    afterPhotos: afterPhotoBytes,
  ),
],
            if (job.operations.any(
  (operation) =>
      operation.repairDescription.trim().isNotEmpty ||
      operation.notes.trim().isNotEmpty,
)) ...[
  pw.SizedBox(height: 20),
  _buildNotes(job),
],

            pw.SizedBox(height: 20),
            _buildTotals(
  job: job,
  laborTotal: laborTotal,
  partsTotal: partsTotal,
  generalChargesTotal: generalChargesTotal,
  discountAmount: job.discountAmount,
  total: total,
),
            pw.SizedBox(height: 28),
            _buildFooter(),
          ];
        },
      ),
    );

    return pdf.save();
  }

  static pw.Widget _buildHeader(
  Job job,
  Uint8List? logoBytes,
) {
    final profile =
    BusinessProfileRepository.instance.profile;
  final invoiceNumber = job.invoiceNumber.trim().isEmpty
      ? 'Pending'
      : job.invoiceNumber.trim();

  final status = job.jobStatus.trim().isEmpty
      ? 'Invoice'
      : job.jobStatus.trim();

  return pw.Column(
    children: [
      pw.Container(
        height: 4,
        decoration: pw.BoxDecoration(
          color: PdfColors.orange600,
          borderRadius: pw.BorderRadius.circular(3),
        ),
      ),
      pw.SizedBox(height: 18),
      pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Expanded(
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
               pw.Container(
  width: 68,
  height: 68,
  alignment: pw.Alignment.center,
  child: logoBytes == null
      ? pw.SizedBox()
      : pw.Image(
          pw.MemoryImage(logoBytes),
          fit: pw.BoxFit.contain,
        ),
),
                pw.SizedBox(width: 16),
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        profile.businessName.trim().isEmpty
    ? 'DocInvoices'
    : profile.businessName,
                        style: pw.TextStyle(
                          color: PdfColors.grey900,
                          fontSize: 21,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 5),
                      pw.Text(
                        profile.tagline.trim().isEmpty
    ? 'Professional field service invoice'
    : profile.tagline,
                        style: const pw.TextStyle(
                          color: PdfColors.grey600,
                          fontSize: 10,
                        ),
                      ),
                      pw.SizedBox(height: 12),
                      pw.Text(
                        [
  profile.phone,
  profile.email,
  profile.fullAddress,
].where((value) => value.trim().isNotEmpty).join(' | '),
                        style: const pw.TextStyle(
                          color: PdfColors.grey700,
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          pw.SizedBox(width: 20),
          pw.Container(
            width: 185,
            padding: const pw.EdgeInsets.all(16),
            decoration: pw.BoxDecoration(
              color: PdfColors.white,
              borderRadius: pw.BorderRadius.circular(12),
              border: pw.Border.all(
                color: PdfColors.grey300,
                width: 0.8,
              ),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'INVOICE',
                  style: pw.TextStyle(
                    color: PdfColors.grey900,
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 10),
                _buildHeaderLine('Invoice #', invoiceNumber),
                if (job.completedDate.trim().isNotEmpty)
  
                    _buildHeaderLine(
                 'Date',
                 job.completedDate.trim(),
                  ),
                pw.SizedBox(height: 10),
                pw.Container(
                  padding: const pw.EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.orange50,
                    borderRadius: pw.BorderRadius.circular(20),
                    border: pw.Border.all(
                      color: PdfColors.orange300,
                      width: 0.7,
                    ),
                  ),
                  child: pw.Text(
                    status.toUpperCase(),
                    style: pw.TextStyle(
                      color: PdfColors.orange800,
                      fontSize: 9,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ],
  );
}
  static pw.Widget _buildHeaderLine(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 5),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            label,
            style: const pw.TextStyle(
              color: PdfColors.grey600,
              fontSize: 9,
            ),
          ),
          pw.SizedBox(width: 8),
          pw.Expanded(
            child: pw.Text(
              value,
              textAlign: pw.TextAlign.right,
              style: pw.TextStyle(
                color: PdfColors.grey900,
                fontSize: 9,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

 static pw.Widget _buildCustomerAndEquipment(Job job) {
  final customerRows = [
    _InfoRow('Name', job.customerName),
    _InfoRow('Location', job.location),
    _InfoRow('PO Number', job.poNumber),
  ].where((row) => row.value.trim().isNotEmpty).toList();

  final equipmentRows = [
  _InfoRow(
    'Equipment',
    job.equipment.isNotEmpty
        ? job.equipment
        : [
            job.vehicleYear,
            job.vehicleMake,
            job.vehicleModel,
          ]
              .where((e) => e.trim().isNotEmpty)
              .join(' '),
  ),
  _InfoRow('Unit Number', job.unitNumber),
  _InfoRow('VIN / Serial', job.vin),
  _InfoRow(
    'Engine',
    [
      job.engineManufacturer,
      job.engineModel,
    ].where((e) => e.trim().isNotEmpty).join(' '),
  ),
  _InfoRow('ESN', job.esn),
  _InfoRow('TSN', job.tsn),
  _InfoRow('Mileage', job.mileage),
].where((row) => row.value.trim().isNotEmpty).toList();

  final customerCard = _buildInfoCard(
    title: 'CUSTOMER',
    rows: customerRows,
  );

  if (equipmentRows.isEmpty) {
    return customerCard;
  }

  return pw.Row(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Expanded(
        child: customerCard,
      ),
      pw.SizedBox(width: 14),
      pw.Expanded(
        child: _buildInfoCard(
          title: 'EQUIPMENT',
          rows: equipmentRows,
        ),
      ),
    ],
  );
}

  static pw.Widget _buildInfoCard({
    required String title,
    required List<_InfoRow> rows,
  }) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: pw.BorderRadius.circular(12),
        border: pw.Border.all(
          color: PdfColors.grey300,
          width: 0.7,
        ),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            title,
            style: pw.TextStyle(
              color: PdfColors.orange800,
              fontSize: 10,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 10),
          ...rows.map(
            (row) => pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 7),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    row.label,
                    style: const pw.TextStyle(
                      color: PdfColors.grey600,
                      fontSize: 8,
                    ),
                  ),
                  pw.SizedBox(height: 2),
                  pw.Text(
                    _displayValue(row.value),
                    style: pw.TextStyle(
                      color: PdfColors.grey900,
                      fontSize: 10,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildOperations(Job job) {
    if (job.operations.isEmpty) {
      return _buildEmptySection(
        title: 'WORK PERFORMED',
        message: 'No operations were added.',
      );
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('WORK PERFORMED'),
        pw.SizedBox(height: 10),
        ...job.operations.map(
          (operation) => pw.Container(
            margin: const pw.EdgeInsets.only(bottom: 14),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(
                color: PdfColors.grey300,
                width: 0.7,
              ),
              borderRadius: pw.BorderRadius.circular(12),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Container(
                  width: double.infinity,
                  padding: const pw.EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 11,
                  ),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.grey900,
                    borderRadius: const pw.BorderRadius.only(
                      topLeft: pw.Radius.circular(12),
                      topRight: pw.Radius.circular(12),
                    ),
                  ),
                  child: pw.Text(
                    operation.title.trim().isEmpty
                        ? 'Operation'
                        : operation.title,
                    style: pw.TextStyle(
                      color: PdfColors.white,
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                
                if (operation.labor.isNotEmpty)
                  _buildLaborTable(operation.labor),
                if (operation.parts.isNotEmpty)
                  _buildPartsTable(operation.parts),
                if (operation.notes.trim().isNotEmpty)
                
                  pw.Container(
                    width: double.infinity,
                    padding: const pw.EdgeInsets.all(12),
                    color: PdfColors.grey100,
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'Operation Notes',
                          style: pw.TextStyle(
                            color: PdfColors.grey700,
                            fontSize: 8,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.SizedBox(height: 4),
                        pw.Text(
                          operation.notes,
                          style: const pw.TextStyle(
                            color: PdfColors.grey800,
                            fontSize: 9,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildLaborTable(List<dynamic> laborItems) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(12),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'LABOR',
            style: pw.TextStyle(
              color: PdfColors.orange800,
              fontSize: 9,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 7),
          _buildTableHeader([
            _TableColumn('Description', 4),
            _TableColumn('Hours', 1),
            _TableColumn('Rate', 1.5),
            _TableColumn('Total', 1.5),
          ]),
          ...laborItems.map(
            (item) => _buildTableRow([
              _TableCell(item.description, 4),
              _TableCell(_number(item.hours), 1),
              _TableCell(_money(item.rate), 1.5),
              _TableCell(_money(item.total), 1.5),
            ]),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildPartsTable(List<dynamic> partItems) {
    return pw.Padding(
      padding: const pw.EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'PARTS',
            style: pw.TextStyle(
              color: PdfColors.orange800,
              fontSize: 9,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 7),
          _buildTableHeader([
            _TableColumn('Description', 4),
            _TableColumn('Qty', 1),
            _TableColumn('Unit Price', 1.5),
            _TableColumn('Total', 1.5),
          ]),
          ...partItems.map(
            (item) => _buildTableRow([
              _TableCell(item.description, 4),
              _TableCell(_number(item.quantity), 1),
              _TableCell(_money(item.unitPrice), 1.5),
              _TableCell(_money(item.total), 1.5),
            ]),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildTableHeader(List<_TableColumn> columns) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 7,
      ),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey200,
        borderRadius: pw.BorderRadius.circular(6),
      ),
      child: pw.Row(
        children: columns
            .map(
              (column) => pw.Expanded(
                flex: (column.flex * 10).round(),
                child: pw.Text(
                  column.label,
                  textAlign: column.label == 'Description'
                      ? pw.TextAlign.left
                      : pw.TextAlign.right,
                  style: pw.TextStyle(
                    color: PdfColors.grey700,
                    fontSize: 8,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  static pw.Widget _buildTableRow(List<_TableCell> cells) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 8,
      ),
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(
            color: PdfColors.grey300,
            width: 0.5,
          ),
        ),
      ),
      child: pw.Row(
        children: cells
            .map(
              (cell) => pw.Expanded(
                flex: (cell.flex * 10).round(),
                child: pw.Text(
                  cell.value,
                  textAlign: cell.flex == 4
                      ? pw.TextAlign.left
                      : pw.TextAlign.right,
                  style: const pw.TextStyle(
                    color: PdfColors.grey800,
                    fontSize: 8.5,
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  static pw.Widget _buildGeneralCharges(Job job) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('SERVICE CHARGES'),
        pw.SizedBox(height: 10),
        pw.Container(
          padding: const pw.EdgeInsets.all(14),
          decoration: pw.BoxDecoration(
            color: PdfColors.grey100,
            borderRadius: pw.BorderRadius.circular(12),
            border: pw.Border.all(
              color: PdfColors.grey300,
              width: 0.7,
            ),
          ),
          child: pw.Column(
            children: job.generalCharges.map(
              (charge) {
                return pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 7),
                  child: pw.Row(
                    children: [
                      pw.Expanded(
                        child: pw.Text(
                          charge.description,
                          style: const pw.TextStyle(
                            color: PdfColors.grey800,
                            fontSize: 9,
                          ),
                        ),
                      ),
                      pw.Text(
                        _money(charge.amount),
                        style: pw.TextStyle(
                          color: PdfColors.grey900,
                          fontSize: 9,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ).toList(),
          ),
        ),
      ],
    );
  }
static pw.Widget _buildRecommendations(Job job) {
  final recommendations = job.operations
      .where(
        (operation) =>
            operation.recommendation.trim().isNotEmpty,
      )
      .toList();

  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      _buildSectionTitle('RECOMMENDED REPAIRS'),
      pw.SizedBox(height: 10),
      ...recommendations.map(
        (operation) => pw.Container(
          width: double.infinity,
          margin: const pw.EdgeInsets.only(bottom: 10),
          padding: const pw.EdgeInsets.all(16),
          decoration: pw.BoxDecoration(
            color: PdfColors.blue50,
            borderRadius: pw.BorderRadius.circular(12),
            border: pw.Border.all(
              color: PdfColors.blue200,
              width: 0.7,
            ),
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                operation.title,
                style: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.grey900,
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                operation.recommendation,
                style: const pw.TextStyle(
                  fontSize: 10,
                  color: PdfColors.grey800,
                  lineSpacing: 3,
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

static pw.Widget _buildJobPhotos({
  required List<Uint8List> beforePhotos,
  required List<Uint8List> afterPhotos,
}) {
  pw.Widget photoColumn(
    String title,
    List<Uint8List> photos,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          title,
          style: pw.TextStyle(
            fontSize: 10,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.grey800,
          ),
        ),
        pw.SizedBox(height: 8),
        ...photos.map(
          (bytes) => pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 10),
            child: pw.Container(
              width: double.infinity,
              height: 180,
              decoration: pw.BoxDecoration(
                borderRadius: pw.BorderRadius.circular(10),
                border: pw.Border.all(
                  color: PdfColors.grey300,
                  width: 0.7,
                ),
              ),
              child: pw.ClipRRect(
                horizontalRadius: 10,
                verticalRadius: 10,
                child: pw.Image(
                  pw.MemoryImage(bytes),
                  fit: pw.BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      _buildSectionTitle('JOB PHOTOS'),
      pw.SizedBox(height: 10),

      if (beforePhotos.isNotEmpty)
        photoColumn('Before', beforePhotos),

      if (afterPhotos.isNotEmpty) ...[
        pw.SizedBox(height: 12),
        photoColumn('After', afterPhotos),
      ],
    ],
  );
}
  static pw.Widget _buildNotes(Job job) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('TECHNICIAN NOTES'),
        pw.SizedBox(height: 10),
        pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.all(16),
          decoration: pw.BoxDecoration(
            color: PdfColors.orange50,
            borderRadius: pw.BorderRadius.circular(12),
            border: pw.Border.all(
              color: PdfColors.orange200,
              width: 0.7,
            ),
          ),
          child: pw.Column(
  crossAxisAlignment: pw.CrossAxisAlignment.start,
  children: job.operations
      .where(
        (operation) =>
            operation.repairDescription.trim().isNotEmpty ||
            operation.notes.trim().isNotEmpty,
      )
      .map(
        (operation) => pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 10),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                operation.title,
                style: pw.TextStyle(
                  color: PdfColors.grey900,
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              
              if (job.operations.any(
  (operation) =>
      operation.recommendation.trim().isNotEmpty,
)) ...[
  pw.SizedBox(height: 20),
  _buildRecommendations(job),
],
              if (operation.repairDescription.trim().isNotEmpty) ...[
                
                pw.SizedBox(height: 4),
                pw.Text(
                  operation.repairDescription,
                  style: const pw.TextStyle(
                    color: PdfColors.grey800,
                    fontSize: 10,
                    lineSpacing: 3,
                  ),
                ),
              ],
              if (operation.notes.trim().isNotEmpty) ...[
                pw.SizedBox(height: 4),
                pw.Text(
                  operation.notes,
                  style: const pw.TextStyle(
                    color: PdfColors.grey700,
                    fontSize: 9,
                    lineSpacing: 3,
                  ),
                ),
              ],
            ],
          ),
        ),
      )
      .toList(),
),


        ),
        
      ],
    );
  }

 static pw.Widget _buildTotals({
  required Job job,
  required double laborTotal,
  required double partsTotal,
  required double generalChargesTotal,
  required double discountAmount,
  required double total,
}) {
  return pw.Row(
    crossAxisAlignment: pw.CrossAxisAlignment.end,
    children: [
      pw.Expanded(
        child: pw.Container(
          padding: const pw.EdgeInsets.all(16),
          decoration: pw.BoxDecoration(
            color: PdfColors.orange50,
            borderRadius: pw.BorderRadius.circular(12),
            border: pw.Border.all(
              color: PdfColors.orange200,
              width: 0.8,
            ),
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Customer Approval',
                style: pw.TextStyle(
                  color: PdfColors.orange800,
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 28),
              pw.Container(
                height: 1,
                color: PdfColors.grey500,
              ),
              pw.SizedBox(height: 5),
              pw.Text(
                'Signature',
                style: const pw.TextStyle(
                  color: PdfColors.grey600,
                  fontSize: 8,
                ),
              ),
            ],
          ),
        ),
      ),
      pw.SizedBox(width: 18),
      pw.Container(
        width: 230,
        padding: const pw.EdgeInsets.all(18),
        decoration: pw.BoxDecoration(
          color: PdfColors.white,
          borderRadius: pw.BorderRadius.circular(14),
          border: pw.Border.all(
            color: PdfColors.grey300,
            width: 0.8,
          ),
        ),
        child: pw.Column(
          children: [
            _buildLightTotalLine('Labor', laborTotal),
            _buildLightTotalLine('Parts', partsTotal),
            ...job.generalCharges.map(
  (charge) => _buildLightTotalLine(
    charge.description.trim().isEmpty
        ? 'Charge'
        : charge.description,
    charge.amount,
  ),
),

            if (discountAmount > 0)
              _buildLightTotalLine(
                'Discount',
                -discountAmount,
              ),
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(vertical: 10),
              child: pw.Container(
                height: 1,
                color: PdfColors.grey300,
              ),
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  'TOTAL',
                  style: pw.TextStyle(
                    color: PdfColors.grey900,
                    fontSize: 13,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Text(
                  _money(total),
                  style: pw.TextStyle(
                    color: PdfColors.orange700,
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ],
  );
}

  static pw.Widget _buildLightTotalLine(
  String label,
  double amount,
) {
  return pw.Padding(
    padding: const pw.EdgeInsets.only(bottom: 7),
    child: pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          label,
          style: const pw.TextStyle(
            color: PdfColors.grey700,
            fontSize: 9,
          ),
        ),
        pw.Text(
          _money(amount),
          style: pw.TextStyle(
            color: PdfColors.grey900,
            fontSize: 9,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}

  static pw.Widget _buildSectionTitle(String title) {
    return pw.Row(
      children: [
        pw.Container(
          width: 5,
          height: 18,
          decoration: pw.BoxDecoration(
            color: PdfColors.orange600,
            borderRadius: pw.BorderRadius.circular(3),
          ),
        ),
        pw.SizedBox(width: 8),
        pw.Text(
          title,
          style: pw.TextStyle(
            color: PdfColors.grey900,
            fontSize: 12,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildEmptySection({
    required String title,
    required String message,
  }) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(title),
        pw.SizedBox(height: 10),
        pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.all(16),
          decoration: pw.BoxDecoration(
            color: PdfColors.grey100,
            borderRadius: pw.BorderRadius.circular(12),
          ),
          child: pw.Text(
            message,
            style: const pw.TextStyle(
              color: PdfColors.grey600,
              fontSize: 9,
            ),
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildFooter() {
    return pw.Column(
      children: [
        pw.Container(
          height: 1,
          color: PdfColors.grey300,
        ),
        pw.SizedBox(height: 8),
        pw.Text(
          'Created with DocInvoices',
          style: const pw.TextStyle(
            color: PdfColors.grey500,
            fontSize: 8,
          ),
        ),
      ],
    );
  }

  static String _displayValue(String value) {
    return value.trim().isEmpty ? 'Not entered' : value.trim();
  }

  static String _money(double value) {
    final sign = value < 0 ? '-' : '';
    return '$sign\$${value.abs().toStringAsFixed(2)}';
  }

  static String _number(double value) {
    if (value == value.roundToDouble()) {
      return value.toStringAsFixed(0);
    }

    return value.toStringAsFixed(2);
  }
}

class _InfoRow {
  const _InfoRow(this.label, this.value);

  final String label;
  final String value;
}

class _TableColumn {
  const _TableColumn(this.label, this.flex);

  final String label;
  final double flex;
}

class _TableCell {
  const _TableCell(this.value, this.flex);

  final String value;
  final double flex;
}