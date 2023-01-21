import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class NetworkService {
  Future<String> authorize() async {
    SVProgressHUD.show(status: 'Loading...');
    final response = await http.get(
        Uri.parse(
            '${dotenv.env['PRODUCTION_URL'] ?? ''}/auth/token/?grant_type=authorization_code'),
        headers: {
          "accept": "application/json",
          "Authorization": dotenv.env['PRODUCTION_AUTHORIZATION'] ?? '',
        });

    if (response.statusCode == 200) {
      SVProgressHUD.dismiss();
      return jsonDecode(response.body)['access_token'];
    } else {
      SVProgressHUD.dismiss();
      return '';
    }
  }

  Future<Map<String, dynamic>> requestPayment(
      {required String accToken,
      required String phoneNumber,
      required int amount}) async {
    final response = await http.post(
        Uri.parse(
            '${dotenv.env['PRODUCTION_URL'] ?? ''}/payments/request-payment/'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": 'Bearer $accToken',
        },
        body: jsonEncode(
          {
            "MerchantCode": dotenv.env['MERCHANT_CODE'] ?? '',
            "NetworkCode": dotenv.env['MP_NETWORK_CODE'] ?? '',
            "PhoneNumber": phoneNumber,
            "TransactionDesc":
                dotenv.env['DEPOSIT_TRANSACTION_DESCRIPTION'] ?? '',
            "AccountReference": phoneNumber,
            "Currency": "KES",
            "Amount": amount,
            "CallBackURL": dotenv.env['CALLBACK_URL'] ?? ''
          },
        ));

    if (response.statusCode == 200) {
      if (jsonDecode(response.body)['ResponseCode'] != "0") {
        return {
          'checkoutRequestId': jsonDecode(response.body)['CheckoutRequestID'],
          'success': false,
          'message': jsonDecode(response.body)['ResponseDescription'],
        };
      } else {
        return {
          'checkoutRequestId': jsonDecode(response.body)['CheckoutRequestID'],
          'success': true,
          'message': jsonDecode(response.body)['ResponseDescription'],
        };
      }
    } else {
      return {
        'success': false,
      };
    }
  }

  Future<Map<String, dynamic>> verifyPayment(
      {required String checkoutReqId, required String accToken}) async {
    final response = await http.post(
        Uri.parse('${dotenv.env['PRODUCTION_URL'] ?? ''}/transactions/status/'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": 'Bearer $accToken',
        },
        body: jsonEncode({
          "MerchantCode": dotenv.env['MERCHANT_CODE'] ?? '',
          "CheckoutRequestId": checkoutReqId,
        }));

    if (response.statusCode == 200) {
      if (jsonDecode(response.body)['status'] != true) {
        return {
          'checkoutRequestId': checkoutReqId,
          'paid': false,
          'tId': '',
          'done': true,
        };
      } else {
        return {
          'checkoutRequestId': jsonDecode(response.body)['data']['CheckoutId'],
          'paid': jsonDecode(response.body)['data']['Paid'],
          'tId': jsonDecode(response.body)['data']['TransID'],
          'done': true,
        };
      }
    } else {
      if (kDebugMode) {
        print("Server did not respond: Status code: ${response.statusCode}");
      }
      return {
        'checkoutRequestId': checkoutReqId,
        'paid': false,
        'tId': '',
        'done': true,
      };
    }
  }

  Future<Map<String, dynamic>> withdrawFunds(
      {required String phone,
      required String accToken,
      required int amount}) async {
    SVProgressHUD.show(status: "Processing...");
    final response = await http.post(
        Uri.parse('${dotenv.env['PRODUCTION_URL'] ?? ''}/payments/b2c/'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": 'Bearer $accToken',
        },
        body: jsonEncode({
          "MerchantCode": dotenv.env['MERCHANT_CODE'] ?? '',
          "MerchantTransactionReference": phone,
          "Amount": amount,
          "Currency": "KES",
          "ReceiverNumber": phone,
          "Channel": dotenv.env['MP_NETWORK_CODE'] ?? '',
          "Reason": dotenv.env['B2C_TRANSACTION_DESCRIPTION'] ?? '',
          "CallBackURL": dotenv.env['B2C_CALLBACK_URL'] ?? '',
        }));

    if (kDebugMode) {
      print("Status: ${response.body}");
    }

    if (response.statusCode == 200) {
      if (jsonDecode(response.body)['status'] != true) {
        SVProgressHUD.dismiss();
        return {
          'paid': false,
          'ResponseCode': '',
          'done': true,
        };
      } else {
        SVProgressHUD.dismiss();
        return {
          'ResponseCode': jsonDecode(response.body)['ResponseCode'],
          'done': true,
        };
      }
    } else {
      if (kDebugMode) {
        print("Server did not respond: Status code: ${response.statusCode}");
      }
      SVProgressHUD.dismiss();
      return {
        'paid': false,
        'tId': '',
        'done': true,
      };
    }
  }
}
