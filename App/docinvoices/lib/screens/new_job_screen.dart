import 'package:flutter/material.dart';
import '../services/vin_lookup_service.dart';
import '../models/job.dart';
import '../models/customer.dart';
import 'package:docinvoices/services/job_repository.dart';
import 'customer_picker_screen.dart';
import 'review_work_screen.dart';
import '../models/operation.dart';
import '../models/general_charge.dart';
import 'customer_screen.dart';
import '../models/customer_unit.dart';
import '../services/customer_unit_repository.dart';
class NewJobScreen extends StatefulWidget {
  const NewJobScreen({
    super.key,
    required this.languageCode,
    this.job,
  });

  final String languageCode;
  final Job? job;

  @override
  State<NewJobScreen> createState() => _NewJobScreenState();
}

class _NewJobScreenState extends State<NewJobScreen> {
  Customer? selectedCustomer;
  CustomerUnit? selectedUnit;
  final TextEditingController customerController =
      TextEditingController();

  final TextEditingController equipmentController =
      TextEditingController();

  final TextEditingController unitController =
      TextEditingController();

  final TextEditingController vinController =
      TextEditingController();
      final TextEditingController esnController =
    TextEditingController();

final TextEditingController tsnController =
    TextEditingController();
final locationController = TextEditingController();
  final mileageController = TextEditingController();
  final complaintController = TextEditingController();
  final serviceCallChargeController =
    TextEditingController();
    final serviceMilesController = TextEditingController();
final TextEditingController customerPhoneController =
    TextEditingController();

final TextEditingController customerEmailController =
    TextEditingController();
final mileageRateController =
    TextEditingController(
  text: '1.50',
);

bool includeServiceCall = false;
bool isLookingUpVin = false;
VinLookupResult? vinLookupResult;
     @override
void initState() {
  super.initState();

  if (widget.job != null) {
    customerController.text = widget.job!.customerName;
    equipmentController.text = widget.job!.equipment;
    unitController.text = widget.job!.unitNumber;
    vinController.text = widget.job!.vin;
    esnController.text = widget.job!.esn;
tsnController.text = widget.job!.tsn;
    locationController.text = widget.job!.location;
    mileageController.text = widget.job!.mileage;
    complaintController.text =
    widget.job!.operations.isNotEmpty
        ? widget.job!.operations.first.title
        : '';

final serviceCharge = widget.job!.generalCharges.where(
  (charge) =>
      charge.description == 'Service Call Charge' ||
      charge.description == 'Cargo por llamada de servicio',
).toList();

final mileageCharge = widget.job!.generalCharges.where(
  (charge) =>
      charge.description == 'Mileage' ||
      charge.description == 'Millaje',
).toList();

includeServiceCall =
    serviceCharge.isNotEmpty || mileageCharge.isNotEmpty;

serviceCallChargeController.text =
    serviceCharge.isNotEmpty
        ? serviceCharge.first.amount.toStringAsFixed(2)
        : '';

mileageRateController.text = '1.50';

if (mileageCharge.isNotEmpty) {
  final double savedMileageTotal =
      mileageCharge.first.amount;

  final double savedRate =
      double.tryParse(mileageRateController.text) ?? 1.50;

  serviceMilesController.text =
      savedRate > 0
          ? (savedMileageTotal / savedRate)
              .toStringAsFixed(1)
          : '';
} else {
  serviceMilesController.clear();
}
  }
  }
 @override
void dispose() {
  customerController.dispose();
  equipmentController.dispose();
  unitController.dispose();
  vinController.dispose();
  esnController.dispose();
tsnController.dispose();
  locationController.dispose();
  mileageController.dispose();
  complaintController.dispose();
  serviceCallChargeController.dispose();
  serviceMilesController.dispose();
  mileageRateController.dispose();
  customerPhoneController.dispose();
  customerEmailController.dispose();
  super.dispose();
}
  
  void _startVoiceCapture() {
  final String customerName = customerController.text.trim();
  

  if (customerName.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.languageCode == 'es'
              ? 'Ingrese el nombre del cliente.'
              : 'Please enter the customer name.',
        ),
      ),
    );

    return;
  }

  // EDIT MODE: update the existing job and return to Review Work.
  if (widget.job != null) {
    final Job existingJob = widget.job!;
    final String updatedComplaint =
    complaintController.text.trim();

if (existingJob.operations.isEmpty) {
  if (updatedComplaint.isNotEmpty) {
    existingJob.operations.add(
      Operation(
        title: updatedComplaint,
        labor: [],
        parts: [],
      ),
    );
  }
} else {
  existingJob.operations.first.title = updatedComplaint;
}

existingJob.generalCharges.removeWhere(
  (charge) =>
      charge.description == 'Service Call Charge' ||
      charge.description == 'Cargo por llamada de servicio' ||
      charge.description == 'Mileage' ||
      charge.description == 'Millaje',
);

final double updatedCallOutFee = includeServiceCall
    ? double.tryParse(
          serviceCallChargeController.text.trim(),
        ) ??
        0.0
    : 0.0;

final double updatedServiceMiles = includeServiceCall
    ? double.tryParse(
          serviceMilesController.text.trim(),
        ) ??
        0.0
    : 0.0;

final double updatedMileageRate = includeServiceCall
    ? double.tryParse(
          mileageRateController.text.trim(),
        ) ??
        0.0
    : 0.0;

if (updatedCallOutFee > 0) {
  existingJob.generalCharges.add(
    GeneralCharge(
      description: widget.languageCode == 'es'
          ? 'Cargo por llamada de servicio'
          : 'Service Call Charge',
      amount: updatedCallOutFee,
    ),
  );
}

final double updatedMileageTotal =
    updatedServiceMiles * updatedMileageRate;

if (updatedMileageTotal > 0) {
  existingJob.generalCharges.add(
    GeneralCharge(
      description: widget.languageCode == 'es'
          ? 'Millaje'
          : 'Mileage',
      amount: updatedMileageTotal,
    ),
  );
}

existingJob.customerName = customerController.text.trim();
existingJob.customerPhone =
    customerPhoneController.text.trim();

existingJob.customerEmail =
    customerEmailController.text.trim();
existingJob.equipment = equipmentController.text.trim();
existingJob.unitNumber = unitController.text.trim();
existingJob.vin = vinController.text.trim();
existingJob.esn = esnController.text.trim();
existingJob.tsn = tsnController.text.trim();
existingJob.location = locationController.text.trim();
existingJob.mileage = mileageController.text.trim();

Navigator.pop(context, existingJob);
return;
}

// NEW JOB MODE: create the job and continue to Voice Capture.
final Job job = Job.createEstimate(
  customerName: customerController.text.trim(),
   customerPhone: customerPhoneController.text.trim(),
  customerEmail: customerEmailController.text.trim(),
  equipment: equipmentController.text.trim(),
  unitNumber: unitController.text.trim(),
  vin: vinController.text.trim(),
  location: locationController.text.trim(),
  mileage: mileageController.text.trim(),
 
 );
 final vinResult = vinLookupResult;

if (vinResult != null) {
  job.vehicleYear = vinResult.year;
  job.vehicleMake = vinResult.make;
  job.vehicleModel = vinResult.model;
  job.engineManufacturer = vinResult.engineManufacturer;
  job.engineModel = vinResult.engineModel;
  job.vehicleType = vinResult.vehicleType;
  job.bodyClass = vinResult.bodyClass;
  job.fuelType = vinResult.fuelType;
  job.gvwrClass = vinResult.gvwrClass;
}
final String complaint = complaintController.text.trim();

if (complaint.isNotEmpty) {
  job.operations.add(
    Operation(
      title: complaint,
      labor: [],
      parts: [],
    ),
  );
}

final double callOutFee = includeServiceCall
    ? double.tryParse(
          serviceCallChargeController.text.trim(),
        ) ??
        0.0
    : 0.0;

final double serviceMiles = includeServiceCall
    ? double.tryParse(
          serviceMilesController.text.trim(),
        ) ??
        0.0
    : 0.0;

final double mileageRate = includeServiceCall
    ? double.tryParse(
          mileageRateController.text.trim(),
        ) ??
        0.0
    : 0.0;

if (callOutFee > 0) {
  job.generalCharges.add(
    GeneralCharge(
      description: widget.languageCode == 'es'
          ? 'Cargo por llamada de servicio'
          : 'Service Call Charge',
      amount: callOutFee,
    ),
  );
}

final double mileageTotal =
    serviceMiles * mileageRate;

if (mileageTotal > 0) {
  job.generalCharges.add(
    GeneralCharge(
      description: widget.languageCode == 'es'
          ? 'Millaje'
          : 'Mileage',
      amount: mileageTotal,
    ),
  );
}


 JobRepository.instance.addJob(job);
job.esn = esnController.text.trim();
job.tsn = tsnController.text.trim();
  Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => ReviewWorkScreen(
      languageCode: widget.languageCode,
      job: job,
    ),
  ),
);
}
Future<void> _selectUnit() async {
  if (selectedCustomer == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.languageCode == 'es'
              ? 'Seleccione un cliente primero.'
              : 'Select a customer first.',
        ),
      ),
    );
    return;
  }

  final customerUnits = CustomerUnitRepository.units
      .where(
        (unit) =>
            unit.customerName.toLowerCase() ==
            selectedCustomer!.name.toLowerCase(),
      )
      .toList();

  if (customerUnits.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.languageCode == 'es'
              ? 'Este cliente no tiene unidades.'
              : 'This customer has no imported units.',
        ),
      ),
    );
    return;
  }

  final CustomerUnit? unit =
      await showModalBottomSheet<CustomerUnit>(
    context: context,
    builder: (context) {
      return ListView.builder(
        itemCount: customerUnits.length,
        itemBuilder: (context, index) {
          final item = customerUnits[index];

          return ListTile(
            leading: const Icon(Icons.local_shipping),
            title: Text(item.unitNumber),
            subtitle: Text(
              '${item.year} ${item.make} ${item.model}',
            ),
            onTap: () {
              Navigator.pop(context, item);
            },
          );
        },
      );
    },
  );

  if (unit == null) return;

  setState(() {
    selectedUnit = unit;

    unitController.text = unit.unitNumber;
    vinController.text = unit.vin;
    equipmentController.text =
        '${unit.year} ${unit.make} ${unit.model}'.trim();
    mileageController.text = unit.mileage;
    esnController.text = unit.esn;
    tsnController.text = unit.tsn;
  });
}
  @override
  Widget build(BuildContext context) {
    final bool isSpanish = widget.languageCode == 'es';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isSpanish ? 'Orden de servicio' : 'Service Order'
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
   TextField(
  controller: customerController,
  readOnly: true,
  onTap: () async {
    final Customer? customer = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CustomerPickerScreen(
  languageCode: widget.languageCode,
),
      ),
    );

    if (customer == null) return;

    setState(() {
  selectedCustomer = customer;
  customerController.text = customer.name;
  customerPhoneController.text = customer.phone;
  customerEmailController.text = customer.email;
});
  },
  decoration: InputDecoration(
    label: Text(
  isSpanish ? 'Buscar cliente' : 'Search Customer',
),
    suffixIcon: const Icon(Icons.people),
  ),
),

    Align(
      alignment: Alignment.centerRight,
      child: TextButton.icon(
        icon: const Icon(Icons.person_add),
        label: Text(
          isSpanish ? 'Nuevo cliente' : 'New Customer',
        ),
        onPressed: () async {
          final Customer? customer = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CustomerScreen(languageCode: '',),
            ),
          );

          if (customer != null) {
  setState(() {
    selectedCustomer = customer;
    customerController.text = customer.name;
    customerPhoneController.text = customer.phone;
    customerEmailController.text = customer.email;
  });
}
        },
      ),
    ),
  ],
),

const SizedBox(height: 16),
TextField(
  controller: esnController,
  decoration: InputDecoration(
    labelText: isSpanish
        ? 'ESN / Número de serie del motor'
        : 'ESN / Engine Serial Number',
  ),
),

const SizedBox(height: 16),

TextField(
  controller: tsnController,
  decoration: InputDecoration(
    labelText: isSpanish
        ? 'TSN / Número de serie de la transmisión'
        : 'TSN / Transmission Serial Number',
  ),
),

const SizedBox(height: 16),
            TextField(
              controller: equipmentController,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: isSpanish
                    ? 'Equipo'
                    : 'Equipment',
              ),
            ),
            const SizedBox(height: 16),

            TextField(
  controller: unitController,
  decoration: InputDecoration(
    labelText: isSpanish
        ? 'Unidad #'
        : 'Unit #',
    suffixIcon: IconButton(
      icon: const Icon(
        Icons.local_shipping_outlined,
      ),
      tooltip: isSpanish
          ? 'Seleccionar unidad'
          : 'Select Unit',
      onPressed: _selectUnit,
    ),
  ),
),
            const SizedBox(height: 16),

            TextField(
  controller: vinController,
  textCapitalization: TextCapitalization.characters,
  decoration: InputDecoration(
    labelText: isSpanish
        ? 'VIN / Número de serie'
        : 'VIN / Serial Number',
    suffixIcon: isLookingUpVin
        ? const Padding(
            padding: EdgeInsets.all(12),
            child: SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            ),
          )
        : IconButton(
            icon: const Icon(Icons.search),
            tooltip: isSpanish
                ? 'Buscar VIN'
                : 'Lookup VIN',
            onPressed: () async {
              final vin =
                  vinController.text.trim();

              if (vin.length != 17) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(
                  SnackBar(
                    content: Text(
                      isSpanish
                          ? 'El VIN debe tener 17 caracteres.'
                          : 'VIN must contain 17 characters.',
                    ),
                  ),
                );
                return;
              }

              setState(() {
                isLookingUpVin = true;
              });

              try {
                final result =
                    await VinLookupService
                        .lookupVin(vin);

                if (!mounted) return;
vinLookupResult = result;
                setState(() {
  equipmentController.text =
      result.equipmentDescription;

  if (widget.job != null) {
    widget.job!.vehicleYear = result.year;
    widget.job!.vehicleMake = result.make;
    widget.job!.vehicleModel = result.model;
    widget.job!.engineManufacturer =
        result.engineManufacturer;
    widget.job!.engineModel = result.engineModel;
    widget.job!.vehicleType = result.vehicleType;
    widget.job!.bodyClass = result.bodyClass;
    widget.job!.fuelType = result.fuelType;
    widget.job!.gvwrClass = result.gvwrClass;
  }
});

               ScaffoldMessenger.of(this.context)
    .showSnackBar(
                  SnackBar(
                    content: Text(
                      isSpanish
                          ? 'VIN encontrado.'
                          : 'VIN decoded successfully.',
                    ),
                  ),
                );
              } catch (error) {
                if (!mounted) return;

               ScaffoldMessenger.of(this.context)
    .showSnackBar(
                  SnackBar(
                    content: Text(error.toString()),
                  ),
                );
              } finally {
                if (mounted) {
                  setState(() {
                    isLookingUpVin = false;
                  });
                }
              }
            },
          ),
  ),
),
            const SizedBox(height: 16),

TextField(
  controller: locationController,
  textCapitalization: TextCapitalization.words,
  decoration: InputDecoration(
    labelText: isSpanish
        ? 'Ubicación'
        : 'Location',
  ),
),
const SizedBox(height: 16),

TextField(
  controller: mileageController,
  keyboardType: TextInputType.number,
  decoration: InputDecoration(
    labelText: isSpanish
        ? 'Millaje'
        : 'Mileage',
  ),
),
TextField(
  controller: complaintController,
  minLines: 3,
  maxLines: 6,
  textCapitalization: TextCapitalization.sentences,
  decoration: InputDecoration(
    labelText: isSpanish
        ? 'Queja / Servicio solicitado'
        : 'Complaint / Requested Service',
    hintText: isSpanish
        ? 'Ejemplo: No arranca'
        : 'Example: No start',
  ),
),
SwitchListTile(
  contentPadding: EdgeInsets.zero,
  title: Text(
    isSpanish
        ? 'Agregar llamada de servicio'
        : 'Add Service Call',
  ),
  subtitle: Text(
    isSpanish
        ? 'Incluya tarifa de llamada y millaje cuando corresponda.'
        : 'Include a call-out fee and mileage when needed.',
  ),
  value: includeServiceCall,
  onChanged: (value) {
    setState(() {
      includeServiceCall = value;

      if (!value) {
        serviceCallChargeController.clear();
        serviceMilesController.clear();
        mileageRateController.clear();
      }
    });
  },
),

if (includeServiceCall) ...[
  const SizedBox(height: 12),

  TextField(
    controller: serviceCallChargeController,
    keyboardType: const TextInputType.numberWithOptions(
      decimal: true,
    ),
    decoration: InputDecoration(
      labelText: isSpanish
          ? 'Tarifa de llamada'
          : 'Call-out Fee',
      prefixText: '\$',
    ),
  ),

  const SizedBox(height: 16),

  Row(
    children: [
      Expanded(
        child: TextField(
          controller: serviceMilesController,
          keyboardType: const TextInputType.numberWithOptions(
            decimal: true,
          ),
          decoration: InputDecoration(
            labelText: isSpanish
                ? 'Millas'
                : 'Miles',
          ),
        ),
      ),
      const SizedBox(width: 14),
      Expanded(
        child: TextField(
          controller: mileageRateController,
          keyboardType: const TextInputType.numberWithOptions(
            decimal: true,
          ),
          decoration: InputDecoration(
            labelText: isSpanish
                ? 'Tarifa por milla'
                : 'Rate per Mile',
            prefixText: '\$',
          ),
        ),
      ),
    ],
  ),
],

const SizedBox(height: 16),

const SizedBox(height: 16),
            const SizedBox(height: 32),

            SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: _startVoiceCapture,
                child: Text(
  widget.job != null
      ? (isSpanish ? 'Guardar cambios' : 'Save Changes')
      : (isSpanish
          ? 'Continuar '
          : 'Continue'),
),
              ),
            ),
          ],
        ),
      ),
    );
  }
}