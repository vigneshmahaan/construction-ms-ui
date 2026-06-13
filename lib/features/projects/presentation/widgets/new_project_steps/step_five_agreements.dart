import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:construction_ms_ui/core/theme/app_colors.dart';

class StepFiveAgreements extends StatelessWidget {
  final TextEditingController notesController;
  final List<PlatformFile> selectedFiles;
  final VoidCallback onPickFiles;
  final Function(int) onRemoveFile;

  const StepFiveAgreements({
    super.key,
    required this.notesController,
    required this.selectedFiles,
    required this.onPickFiles,
    required this.onRemoveFile,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Section 5 - Agreements',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Text(
              'UPLOAD AGREEMENT DOCUMENTS',
              style: TextStyle(
                color: Color(0xFF64748B),
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
            ),
          ),
          OutlinedButton.icon(
            onPressed: onPickFiles,
            icon: const Icon(Icons.file_upload_outlined, color: AppColors.primary),
            label: const Text(
              'Select Files',
              style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
            ),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 56),
              backgroundColor: const Color(0xFFF1F5F9),
              side: const BorderSide(color: Color(0xFFE2E8F0)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Supported: PDF, DOCX, JPG',
            style: TextStyle(color: Color(0xFF64748B), fontSize: 12),
          ),
          const SizedBox(height: 16),
          if (selectedFiles.isNotEmpty)
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: selectedFiles.length,
              itemBuilder: (context, index) {
                final file = selectedFiles[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.description_outlined, color: AppColors.primary, size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          file.name,
                          style: const TextStyle(color: AppColors.textDark, fontSize: 14),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.black54, size: 20),
                        onPressed: () => onRemoveFile(index),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                );
              },
            ),
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Text(
              'KEY TERMS / NOTES',
              style: TextStyle(
                color: Color(0xFF64748B),
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
            ),
          ),
          TextFormField(
            controller: notesController,
            maxLines: 6,
            style: const TextStyle(color: AppColors.textDark, fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Any special clauses or terms...',
              hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
              filled: true,
              fillColor: const Color(0xFFF1F5F9),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.primary),
              ),
            ),
          ),
          const SizedBox(height: 100), // spacing for sticky bottom bar
        ],
      ),
    );
  }
}
