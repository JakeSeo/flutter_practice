import 'package:flutter/material.dart';
import 'package:sendbird_sample/components/custom_button.dart';
import 'package:sendbird_sdk/sendbird_sdk.dart';

class CreateGroupChannelForm extends StatefulWidget {
  const CreateGroupChannelForm({
    super.key,
    required this.onCreate,
  });

  final Future<void> Function({
    required GroupChannelParams params,
  }) onCreate;

  @override
  State<CreateGroupChannelForm> createState() => _CreateGroupChannelFormState();
}

class _CreateGroupChannelFormState extends State<CreateGroupChannelForm> {
  static const List<String> typeList = ['타입 1', '타입 2', '타입 3'];
  final _formKey = GlobalKey<FormState>();
  bool _isPublic = false;
  bool _isDiscoverable = true;
  String _selectedType = typeList[0];
  final TextEditingController _accessCodeController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  List<String> _userList = ['sympton70@gmail.com'];
  List<String> _operatorList = ['sympton70@gmail.com'];

  bool _submitPressed = false;
  bool _isLoading = false;

  _setIsPublic(bool value) {
    setState(() {
      _isPublic = value;
    });
  }

  _setIsDiscoverable(bool value) {
    setState(() {
      _isDiscoverable = value;
    });
  }

  String? _validateName(String? value) {
    if (!_submitPressed) return null;
    if (value == null || value.isEmpty) {
      return '그룹명을 입력해주세요.';
    }
    return null;
  }

  _onCreate(BuildContext context) async {
    if (!_submitPressed) {
      setState(() {
        _submitPressed = true;
      });
    }

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    GroupChannelParams params = GroupChannelParams();
    params.name = _nameController.text;
    params.customType = _selectedType;
    params.isPublic = _isPublic;
    if (_isPublic) {
      params.accessCode = _accessCodeController.text.isEmpty
          ? null
          : _accessCodeController.text;
      params.isDiscoverable = _isDiscoverable;
    }
    params.userIds = _userList;
    params.operatorUserIds = _operatorList;

    print(params.isPublic);

    await widget.onCreate(params: params);

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 24),
            TextFormField(
              controller: _nameController,
              validator: _validateName,
              decoration: const InputDecoration(hintText: "그룹명"),
              onChanged: (_) {
                _formKey.currentState?.validate();
              },
            ),
            const SizedBox(height: 16),
            DropdownButton<String>(
              isExpanded: true,
              value: _selectedType,
              items: typeList
                  .map(
                    (item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedType = value ?? typeList[0];
                });
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _setIsPublic(true),
                    child: Row(
                      children: [
                        Radio<bool>(
                          value: true,
                          groupValue: _isPublic,
                          onChanged: (value) => _setIsPublic(value ?? true),
                        ),
                        const Expanded(
                          child: Text("공개 채널"),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () => _setIsPublic(false),
                    child: Row(
                      children: [
                        Radio<bool>(
                          value: false,
                          groupValue: _isPublic,
                          onChanged: (value) => _setIsPublic(value ?? false),
                        ),
                        const Expanded(
                          child: Text("비공개 채널"),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_isPublic)
              Column(
                children: [
                  TextFormField(
                    controller: _accessCodeController,
                    decoration: const InputDecoration(
                      hintText: "엑세스 코드",
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => _setIsDiscoverable(true),
                          child: Row(
                            children: [
                              Radio<bool>(
                                value: true,
                                groupValue: _isDiscoverable,
                                onChanged: (value) =>
                                    _setIsDiscoverable(value ?? true),
                              ),
                              const Expanded(
                                child: Text("검색 가능"),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () => _setIsDiscoverable(false),
                          child: Row(
                            children: [
                              Radio<bool>(
                                value: false,
                                groupValue: _isDiscoverable,
                                onChanged: (value) =>
                                    _setIsDiscoverable(value ?? false),
                              ),
                              const Expanded(
                                child: Text("검색  불가능"),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            CustomButton(
              text: '그룹채널 생성',
              isLoading: _isLoading,
              onPressed: () => _onCreate(context),
            ),
          ],
        ),
      ),
    );
  }
}
