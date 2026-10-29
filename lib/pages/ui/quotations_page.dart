import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tag_tweaker/controllers/favourites_controller.dart';
import 'package:tag_tweaker/controllers/pdf_preview_controller.dart';
import 'package:tag_tweaker/models/quotation.dart';
import 'package:tag_tweaker/pages/ui/pdf_preview_page.dart';
import 'package:tag_tweaker/services/catalog_pdf_service.dart';
import 'package:tag_tweaker/services/quotation_repository.dart';
import 'package:tag_tweaker/themes/neo_brutal_theme.dart';
import 'package:tag_tweaker/utils/money.dart';
import 'package:tag_tweaker/widgets/common/app_background.dart';
import 'package:tag_tweaker/widgets/custom_snackbar.dart';

/// History of saved client quotations. Tap to re-export, swipe to delete.
class QuotationsPage extends StatelessWidget {
  const QuotationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = Get.find<QuotationRepository>();
    final uid = Get.find<FavouritesController>().currentUid;

    return Scaffold(
      backgroundColor: NeoBrutalColors.background,
      body: Stack(
        children: [
          const AppBackground(),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(),
                Expanded(
                  child: uid == null
                      ? const _EmptyHistory()
                      : StreamBuilder<List<Quotation>>(
                          stream: repo.watch(uid),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return const _EmptyHistory(
                                message: 'Could not load quotations.',
                              );
                            }
                            if (!snapshot.hasData) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: NeoBrutalColors.lime,
                                ),
                              );
                            }
                            final quotes = snapshot.data!;
                            if (quotes.isEmpty) return const _EmptyHistory();
                            return ListView.separated(
                              padding: const EdgeInsets.all(24),
                              itemCount: quotes.length,
                              separatorBuilder: (_, _) =>
                                  const SizedBox(height: 16),
                              itemBuilder: (context, i) => _QuotationCard(
                                quote: quotes[i],
                                onDelete: () => repo.delete(uid, quotes[i].id!),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: NeoBrutalColors.white, width: 4),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: Get.back,
            child: Container(
              width: 48,
              height: 48,
              decoration: NeoBrutalTheme.brutalBox(
                color: NeoBrutalColors.white,
                borderColor: NeoBrutalColors.black,
                shadowColor: NeoBrutalColors.black,
              ),
              child: const Icon(Icons.arrow_back, color: NeoBrutalColors.black),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            'QUOTATION\nHISTORY',
            style: NeoBrutalTheme.heading.copyWith(
              fontSize: 24,
              height: 0.9,
              shadows: const [
                Shadow(offset: Offset(2, 2), color: NeoBrutalColors.lime),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuotationCard extends StatelessWidget {
  final Quotation quote;
  final Future<void> Function() onDelete;

  const _QuotationCard({required this.quote, required this.onDelete});

  void _open() {
    unawaited(
      Get.to(
        () => const PdfPreviewPage(),
        binding: BindingsBuilder(() {
          Get.put(
            PdfPreviewController(
              pdfGenerator: () => CatalogPdfService.generateQuotationPdf(quote),
            ),
          );
        }),
      ),
    );
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: NeoBrutalColors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
          side: BorderSide(color: NeoBrutalColors.black, width: 3),
        ),
        title: Text(
          'DELETE QUOTE?',
          style: NeoBrutalTheme.heading.copyWith(
            color: NeoBrutalColors.black,
            fontSize: 20,
          ),
        ),
        content: Text(
          'This removes it from your history.',
          style: NeoBrutalTheme.body.copyWith(color: NeoBrutalColors.black),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'CANCEL',
              style: NeoBrutalTheme.heading.copyWith(
                color: NeoBrutalColors.black,
                fontSize: 14,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'DELETE',
              style: NeoBrutalTheme.heading.copyWith(
                color: NeoBrutalColors.orange,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
    return confirmed ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final d = quote.createdAt;
    final date =
        '${d.day.toString().padLeft(2, '0')}/'
        '${d.month.toString().padLeft(2, '0')}/${d.year}';

    return Dismissible(
      key: ValueKey(quote.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) => _confirmDelete(context),
      onDismissed: (_) async {
        try {
          await onDelete();
        } catch (_) {
          CustomSnackbar.showError(
            title: 'ERROR',
            message: 'Could not delete quotation',
          );
        }
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        color: NeoBrutalColors.orange,
        child: const Icon(Icons.delete_outline, color: NeoBrutalColors.black),
      ),
      child: GestureDetector(
        onTap: _open,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: NeoBrutalTheme.brutalBox(
            color: NeoBrutalColors.white,
            borderColor: NeoBrutalColors.black,
            shadowColor: NeoBrutalColors.lime,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      quote.clientName.isEmpty
                          ? 'WALK-IN CLIENT'
                          : quote.clientName.toUpperCase(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: NeoBrutalTheme.heading.copyWith(
                        fontSize: 16,
                        color: NeoBrutalColors.black,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '$date  ·  ${quote.itemCount} '
                      '${quote.itemCount == 1 ? 'item' : 'items'}',
                      style: NeoBrutalTheme.body.copyWith(
                        fontSize: 12,
                        color: NeoBrutalColors.lightGrey,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '₹${formatMoney(quote.totals.total)}',
                style: NeoBrutalTheme.mono.copyWith(
                  fontSize: 16,
                  color: NeoBrutalColors.black,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.picture_as_pdf, color: NeoBrutalColors.purple),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyHistory extends StatelessWidget {
  final String message;

  const _EmptyHistory({
    this.message = 'No quotations yet.\nCreate one from your favourites.',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: NeoBrutalTheme.body.copyWith(
            color: NeoBrutalColors.white.withValues(alpha: 0.7),
          ),
        ),
      ),
    );
  }
}
