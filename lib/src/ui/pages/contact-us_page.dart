import 'package:agent_pet/src/base/services.dart';
import 'package:agent_pet/src/base/theme.dart';
import 'package:agent_pet/src/utils/lazy_task.dart';
import 'package:agent_pet/src/utils/validators.dart';
import 'package:agent_pet/src/widgets/app_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ContactDetail {
  String name;
  String email;
  String subject;
  String message;

  ContactDetail({
    this.name = '',
    this.email = '',
    this.subject = '',
    this.message = '',
  });
}

class ContactUsPage extends StatelessWidget {
  final detail = ContactDetail();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Contact Us'),
        ),
        body: Form(
          key: formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 30),
                child: Text.rich(
                  TextSpan(
                    text: 'Feel free to drop by or Call to say ',
                    style: TextStyle(fontSize: 24),
                    children: [
                      TextSpan(
                        text: 'Hello!',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ]
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              AppTextField(
                label: 'Your Full Name',
                validator: Validators.required,
                onSaved: (value) => detail.name = value,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: AppTextField(
                  label: 'Your Email',
                  validator: Validators.requiredEmail,
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (value) => detail.email = value,
                ),
              ),
              AppTextField(
                label: 'Subject',
                validator: Validators.required,
                onSaved: (value) => detail.subject = value,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 50),
                child: AppTextField(
                  label: 'Message',
                  maxLines: 4,
                  validator: Validators.required,
                  onSaved: (value) => detail.message = value,
                ),
              ),

              TextButton(
                style: AppTheme.extendedPrimaryTextButton,
                // label: Icon(Icons.send),
                child: Text('Send Message'),
                onPressed: () async {
                  if (formKey.currentState.validate()) {
                    await performLazyTask(context, () async {
                    });

                    AppServices.scaffoldMessenger.currentState.showSnackBar(SnackBar(
                      content: Text('We have received your message and will contact you shortly.'),
                    ));
                  }
                },
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
