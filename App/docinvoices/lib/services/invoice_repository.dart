import '../models/invoice.dart';

class InvoiceRepository {
  InvoiceRepository._();

  static final InvoiceRepository instance = InvoiceRepository._();

  final List<Invoice> _invoices = [];

  List<Invoice> get invoices => List.unmodifiable(_invoices);

  void addInvoice(Invoice invoice) {
    _invoices.add(invoice);
  }

  void updateInvoice(Invoice updatedInvoice) {
    final index = _invoices.indexWhere(
      (invoice) => invoice.id == updatedInvoice.id,
    );

    if (index == -1) {
      return;
    }

    _invoices[index] = updatedInvoice;
  }

  void deleteInvoice(String invoiceId) {
    _invoices.removeWhere(
      (invoice) => invoice.id == invoiceId,
    );
  }

  Invoice? findById(String invoiceId) {
    for (final invoice in _invoices) {
      if (invoice.id == invoiceId) {
        return invoice;
      }
    }

    return null;
  }

  double get totalInvoiced {
    return _invoices.fold(
      0,
      (total, invoice) => total + invoice.total,
    );
  }

  double get totalOutstanding {
    return _invoices.fold(
      0,
      (total, invoice) => total + invoice.balance,
    );
  }

  double get totalPaid {
    return _invoices
        .where((invoice) => invoice.status == 'Paid')
        .fold(
          0,
          (total, invoice) => total + invoice.total,
        );
  }
}