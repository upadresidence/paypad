//https://medium.com/flutterpub/mocking-http-request-in-flutter-c2596eea55f2
import 'dart:async';

import 'package:http/http.dart';
//import '../models/item_model.dart';
//import 'dart:convert';
import 'package:paypad/services/rest/models/paymaya/sandbox_paymaya_credential.dart';

import 'package:paypad/services/rest/routes/paymaya.dart';

Client client = Client();

class Api {
  static dynamic paymaya_routes = new PaymayaRoutes();
  //static dynamic gcash_routes = new GcashRoutes();
  //static dynamic paypayl_routes = new PaypalRoutes();

  static dynamic currentRoute;

  static dynamic executeRequest(dynamic model, String action) {
    switch (model.PROVIDER) {
      case 'paymaya':
        currentRoute = paymaya_routes;
    }

    switch (action) {
      case 'token':
        return paymaya_routes.generatePaymentTokens(model);
      case 'single_pay':
        return paymaya_routes.paySingle(model);
    }
  }

/*
execute() {
  print(
    SandboxMaymayaCredential.getAuthentication()
    );
}
*/
/*
//Authorization: Basic c2stalpLMGk4eVozMHBoOHhRU1dsTnNGOUFNV2ZHT2QzQmF4SmpRMkNEQ0NaYjo=
  execute() async {
    var checkout_id= '044292b5-ed90-429b-9b39-797b1d85f356';
    var url = 'https://pg-sandbox.paymaya.com/checkout/v1/checkouts/' + checkout_id;
    
    var response = await client.get(url, 
                            headers: {
                              'Authorization':'Basic c2stalpLMGk4eVozMHBoOHhRU1dsTnNGOUFNV2ZHT2QzQmF4SmpRMkNEQ0NaYjo='
                            }
                          );
    print(response.body);
  }
  */
}
