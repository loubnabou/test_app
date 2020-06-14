import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mailer2/mailer.dart';

class SendEmails {
  static Future<String> sendMail(
      List<String> emails, String from, String key) async {
    String msgResponse;
    String body = '<h2>Bonjour,</h2>' +
        '<p>I would like to inform you that there is a new Test added</p>' +
        '<p>Visit our app or download it now from below link ' +
        'to make a Test.</p>' +
        '<center><h4 style="display:inline">Password: </h4><h2 style="display:inline">$key</h2></center>' +
        '<p>Don\'t forget to enter this password to show the Test</p>' +
        '<center><h5>© 2020 Company Inc.</h5></center>' +
        '<center><h1>Have fun & Good Bye 😍</h1></center>';

    String username = 'team.mailer01';
    String password = '01111953134';

    var options = new GmailSmtpOptions()
      ..username = username
      ..password = password;

    var emailTransport = new SmtpTransport(options);

    emails.forEach((email) {
      // create our mail
      final message = Envelope()
        ..fromName = from
        ..recipients.add(email)
        ..subject = 'New Test Added 😍'
        ..html = body;

      emailTransport
          .send(message)
          .then((envelope) => msgResponse = 'sent')
          .catchError((error) => msgResponse = error);
    });

    return msgResponse;
  }

  static Future<String> sendResultMail(
      candidateEmail, String from, String detailsMSG) async {
    String msgResponse;
    String body = '<h2>Bonjour,</h2>' +
        '<p>I would like to inform you that you finished test and this is Info about you</p>' +
        '<center><h2>$detailsMSG</h2></center>' +
        '<center><h3>Best Wishes & Good Bye 😍</h3></center>' +
        '<center><h4>© 2020 Company Inc.</h4></center>';

    String username = 'team.mailer01';
    String password = '01111953134';

    var options = new GmailSmtpOptions()
      ..username = username
      ..password = password;

    var emailTransport = new SmtpTransport(options);

    // create our mail
    final message = Envelope()
      ..fromName = from
      ..recipients.add(candidateEmail)
      ..subject = 'Results 😍'
      ..html = body;

    emailTransport
        .send(message)
        .then((envelope) => msgResponse = 'sent')
        .catchError((error) => msgResponse = error);

    return msgResponse;
  }
}
