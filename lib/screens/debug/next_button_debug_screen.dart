/// Debug Screen for NextButton States
/// This screen visually demonstrates all NextButton states and the ValueKey fix
/// Run this screen to verify SVG asset switching is working correctly
library;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../widgets/next_button.dart';
import '../../theme/app_theme.dart';

class NextButtonDebugScreen extends StatefulWidget {
  const NextButtonDebugScreen({super.key});

  @override
  State<NextButtonDebugScreen> createState() => _NextButtonDebugScreenState();
}

class _NextButtonDebugScreenState extends State<NextButtonDebugScreen> {
  bool _isDisabled = true;
  int _tapCount = 0;
  String _lastAction = 'None';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text('NextButton Debug'),
        backgroundColor: AppColors.cream,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section 1: Static State Comparison
            _buildSection(
              'Static State Comparison',
              'All three SVG states displayed side by side',
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStaticButton('Default', 'assets/images/NextButton/Default.svg'),
                  _buildStaticButton('Disabled', 'assets/images/NextButton/Disabled.svg'),
                  _buildStaticButton('Pressed', 'assets/images/NextButton/Pressed.svg'),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Section 2: Interactive Toggle Test
            _buildSection(
              'Interactive Toggle Test',
              'Toggle between enabled/disabled states to verify ValueKey fix',
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Disabled: ', style: TextStyle(fontSize: 16)),
                      Switch(
                        value: _isDisabled,
                        onChanged: (value) {
                          setState(() {
                            _isDisabled = value;
                            _lastAction = value ? 'Switched to DISABLED' : 'Switched to ENABLED';
                          });
                        },
                        activeColor: Colors.red,
                        inactiveThumbColor: Colors.green,
                      ),
                      Text(
                        _isDisabled ? 'YES' : 'NO',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _isDisabled ? Colors.red : Colors.green,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _isDisabled ? Colors.red.shade200 : Colors.green.shade200,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      children: [
                        NextButton(
                          onPressed: _isDisabled
                              ? null
                              : () {
                                  setState(() {
                                    _tapCount++;
                                    _lastAction = 'Button tapped! (count: $_tapCount)';
                                  });
                                },
                          isDisabled: _isDisabled,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Expected: ${_isDisabled ? "GRAY (Disabled.svg)" : "GRADIENT (Default.svg)"}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: _isDisabled ? Colors.grey : Colors.amber.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Text('Last Action: $_lastAction'),
                        Text('Tap Count: $_tapCount'),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Section 3: Bug Verification Instructions
            _buildSection(
              'How to Verify the Fix',
              'Follow these steps to confirm the bug is fixed',
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.yellow.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.yellow.shade200),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('1. Look at the "Interactive Toggle Test" section above'),
                    SizedBox(height: 8),
                    Text('2. Toggle the switch OFF (disabled = NO)'),
                    SizedBox(height: 8),
                    Text('3. Button should show GRADIENT (gold/amber color)'),
                    SizedBox(height: 8),
                    Text('4. Toggle the switch ON (disabled = YES)'),
                    SizedBox(height: 8),
                    Text('5. Button should show GRAY (#E0E0E0)'),
                    SizedBox(height: 8),
                    Text('6. Toggle back and forth - button should update correctly'),
                    SizedBox(height: 16),
                    Text(
                      '❌ BUG (before fix): Button stays gradient even when disabled',
                      style: TextStyle(color: Colors.red),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '✅ FIXED: Button correctly switches between gradient and gray',
                      style: TextStyle(color: Colors.green),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Section 4: Technical Details
            _buildSection(
              'Technical Details',
              'ValueKey implementation',
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'The Fix:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'SvgPicture.asset(\n'
                      '  _assetPath,\n'
                      '  key: ValueKey(_assetPath), // <-- This line\n'
                      '  ...\n'
                      ')',
                      style: TextStyle(fontFamily: 'monospace', fontSize: 12),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Why it works:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Flutter\'s widget reconciliation caches widgets by type. '
                      'When the asset path changes, Flutter doesn\'t rebuild because '
                      'the widget type (SvgPicture) is the same. Adding ValueKey(_assetPath) '
                      'gives each asset a unique identity, forcing Flutter to create '
                      'a new widget when the path changes.',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String subtitle, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 16),
        content,
      ],
    );
  }

  Widget _buildStaticButton(String label, String assetPath) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: SvgPicture.asset(
            assetPath,
            key: ValueKey(assetPath),
            width: 54,
            height: 54,
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
