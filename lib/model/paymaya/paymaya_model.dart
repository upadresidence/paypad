//https://developers.paymaya.com/blog/entry/api-test-merchants-and-test-cards
//https://s3-ap-southeast-1.amazonaws.com/developers.paymaya.com.checkout/checkout.html#checkout-payment-page-checkout-endpoints-post

//import 'package:flutter/material.dart';
//import 'package:http/http.dart' as http;

import 'package:rest_api_lib/services/rest/config/paymaya.dart';

import 'package:paypad/model/paymaya/PaymentToken.dart';


import 'package:http/http.dart';

Client client = Client();

String BASE_PATH = 'https://pg-sandbox.paymaya.com/';
String PAYMENT_PATH = BASE_PATH + 'payments/';

class PaymayaRoutes {
  String PAYMENT_TOKEN_PATH = BASE_PATH +
      PAYMENT_PATH +
      'v1/payment-tokens'; //POST https://pg-sandbox.paymaya.com/payments/v1/payment-tokens
  String PAYMENTS_PATH = BASE_PATH +
      PAYMENT_PATH +
      'v1/payments/'; //POST https://pg-sandbox.paymaya.com/payments/v1/payments GET https://pg-sandbox.paymaya.com/payments/v1/payments/b546e900-1097-455a-999e-c2316e3b4809
  String PAYMENT_REFERENCE_PATH = BASE_PATH +
      PAYMENT_PATH +
      'v1/payment-rrns/'; //GET https://pg-sandbox.paymaya.com/payments/v1/payment-rrns/REF0001234
/*
  generatePaymentTokens(Map <String, dynamic >out_headers, Map <String, dynamic >out_body) async {
    var response = await client.post(
      PAYMENT_TOKEN_PATH,
      headers: out_headers,
      body: out_body
    );

    return response;
  }
  */

  generatePaymentTokens(dynamic model) async {
    var response = await client.post(PAYMENT_TOKEN_PATH,
        headers: model.getHeader(), body: model.getRequest());

    return response;
  }

/*
  paySingle(Map <String, dynamic >out_headers, Map <String, dynamic >out_body) async {
    var response = await client.post(
      PAYMENTS_PATH,
      headers: out_headers,
      body: out_body
    );
 
    return response;
  }
  */
  paySingle(dynamic model) async {
    var response = await client.post(PAYMENTS_PATH,
        headers: model.getHeader(), body: model.getRequest());

    return response;
  }

  fetchPayment(dynamic uri_params, Map<String, dynamic> out_headers) async {
    var response = await client.get(PAYMENTS_PATH + uri_params['payment_id'],
        headers: out_headers);

    return response;
  }

  fetchPaymentReference(
      dynamic uri_params, Map<String, dynamic> out_headers) async {
    var response = await client.get(
        PAYMENTS_PATH + uri_params['request_reference_number'],
        headers: out_headers);

    return response;
  }
/*
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

/*

   
Test Cards

CARD TYPE
	

NUMBER
	

EXPIRY YEAR
	

EXPIRY MONTH
	

CSC/CVV
	

3-D Secure PASSWORD

MASTERCARD
	

5123456789012346
	

19
	

05
	

111
	

Not enabled
MASTERCARD 	5453010000064154 	19 	05 	111 	secbarry1

VISA
	

4123450131001381
	

19
	

05
	

123
	

mctest1

VISA
	

4123450131001522
	

19
	

05
	

123
	

mctest1

VISA
	

4123450131004443
	

19
	

05
	

123
	

mctest1

VISA
	

4123450131000508
	

19
	

05
	

111
	

Not enabled
API Keys
MERCHANT NAME 	SECRET API KEY 	PUBLIC-FACING API KEY 	USE FOR
Sandbox Party 	sk-jZK0i8yZ30ph8xQSWlNsF9AMWfGOd3BaxJjQ2CDCCZb 	pk-nRO7clSfJrojuRmShqRbihKPLdGeCnb9wiIWF8meJE9 	Checkout
Sandbox Party 2 	sk-vb27oxKsTzWTAiil0zvu8aflo4I3h5cvcVCa0HdVyrt 	pk-zkE0dIHQuDQEdWXJM547lhyX8IXLJRmpQ2tnmVIS5eo 	Checkout
Sandbox Party 3 	sk-SNCvnXbvtAxU6mszPMoDl2M1d4e1ivko1E6PLGiOiqm 	pk-TnpIh5X432Qw1DJLlMhzxRhBN4fvUp3SHPuHT3m5wv6 	Checkout
Sandbox Party 4 	sk-bi6bdLEfFd1GH6T6bF19vvI3kXc5gvTDJWbpDL3QWeK 	pk-A8aEsptjZGXar9At3ZPKH0DlUZge5UKXFqloeGDtARm 	Checkout
Sandbox Party 5 	sk-BoTm71oqA1jdCd6bwLwxK3QsVPo9ZOcr1dpYfyAPUUd 	pk-6y2WX6WhWxfQOg8ezKIUuiJxa7gC4sDvOipn9NFXlwz 	Payment Vault


*/

/*


//NETWORK Request
  Future<http.Response> fetchModel() {
    return http.get('https://jsonplaceholder.typicode.com/posts/1');
  }

  Future<Model> fetchModel() async {
    final response =
        await http.get('https://jsonplaceholder.typicode.com/posts/1');

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON
      return Model.fromJson(json.decode(response.body));
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load Model');
    }
  }


//MODEL with json to model Converter
  class Model {
    final int userId;
    final int id;
    final String title;
    final String body;

    Model({this.userId, this.id, this.title, this.body});

    factory Model.fromJson(Map<String, dynamic> json) {
      return Model(
        userId: json['userId'],
        id: json['id'],
        title: json['title'],
        body: json['body'],
      );
    }
}


//FETCH
  FutureBuilder<Model>(
    future: fetchModel(),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        return Text(snapshot.data.title);
      } else if (snapshot.hasError) {
        return Text("${snapshot.error}");
      }

      // By default, show a loading spinner
      return CircularProgressIndicator();
    },
  );

  In order to fetch the data and display it on screen, we can use the FutureBuilder widget! The FutureBuilder Widget comes with Flutter and makes it easy to work with async data sources.

  We must provide two parameters:

      The Future we want to work with. In our case, we’ll call our fetchPost() function.
      A builder function that tells Flutter what to render, depending on the state of the Future: loading, success, or error.

  FutureBuilder<Post>(
    future: fetchPost(),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        return Text(snapshot.data.title);
      } else if (snapshot.hasError) {
        return Text("${snapshot.error}");
      }

      // By default, show a loading spinner
      return CircularProgressIndicator();
    },
  );












import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:remo/services/rest/config/creds.dart';

import 'package:remo/services/rest/models/AuthUnionBank.dart';


final BASE_URL = 'https://api-uat.unionbankph.com/partners/sb/';

class Api {
  final String get_path1 = 'convergent/v1/oauth2/authorize';


  

}
/*
static Future<List<AuthUnionBank>> getAuthorize() async {

    final response = await http.get(BASE_URL + 'forex/v1/rates', 
                                  headers: {"x-ibm-client-id": creds_client_id,
                                            "x-ibm-client-secret": creds_client_secret});
    print(response.body);
    List responseJson = json.decode(response.body.toString());
    List<ModelTest> model_test = createForeXFromList(responseJson);
    
    
    return model_test;

static List<AuthUnionBank> createForeXFromList(List data) {
    List<AuthUnionBank> list = new List();
    for (int i = 0; i < data.length; i++) {
      AuthUnionBank mo_test = new AuthUnionBank(id: data[i]["id"] ,
                                        symbol: data[i]["symbol"] ,
                                        name: data[i]["name"] ,
                                        buying: data[i]["buying"] ,
                                        selling: data[i]["selling"] ,
                                        asOf: data[i]["asOf"] );
      list.add(mo_test);
    }
    return list;
  }

*/
 */
