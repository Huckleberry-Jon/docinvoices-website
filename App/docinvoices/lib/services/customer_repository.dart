import '../models/customer.dart';

class CustomerRepository {
  CustomerRepository._();

  static final List<Customer> _customers = [];

  static List<Customer> get customers =>
      List.unmodifiable(_customers);

  static void addCustomer(Customer customer) {
    _customers.add(customer);
  }
}