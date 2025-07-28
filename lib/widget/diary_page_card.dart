import 'package:flutter/material.dart';
import 'package:my_first_app/constants/colors.dart';

class DiaryPageCard extends StatelessWidget {
  final Map<String, dynamic> diaryData;
  final bool isLastPage;
  final bool isMyDiary;
  final VoidCallback? onAddPressed;
  final VoidCallback? onToggleRevealed;
  final VoidCallback? onImageTap;
  final String groupId;
  final String date;
  final String diaryId;

  const DiaryPageCard({
    super.key,
    required this.diaryData,
    required this.isLastPage,
    required this.isMyDiary,
    required this.groupId,
    required this.date,
    required this.diaryId,
    this.onAddPressed,
    this.onToggleRevealed,
    this.onImageTap,
  });

  @override
  Widget build(BuildContext context) {
    print(
      '📦 [DiaryPageCard] build 실행됨 - diaryId: $diaryId, imageUrl: ${diaryData['imageUrl']}, isRevealed: ${diaryData['isRevealed']}',
    );

    final imageUrl = (diaryData['imageUrl'] as String?)?.trim();
    final title = diaryData['title'] ?? '';
    final content = diaryData['content'] ?? '';
    final isRevealed = diaryData['isRevealed'] ?? false;
    final createdByNickname = diaryData['createdByNickname'] ?? '익명';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 닉네임은 공개된 일기에서만 표시
            if (isRevealed && createdByNickname.isNotEmpty) ...[
              Row(
                children: [
                  const Icon(Icons.person, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    createdByNickname,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],

            // 이미지 표시
            if (imageUrl != null)
              GestureDetector(
                onTap: isRevealed ? onImageTap : null,
                child: Image.network(
                  imageUrl,
                  height: 250,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(Icons.error, size: 100, color: Colors.red),
                    );
                  },
                ),
              )
            else
              const Icon(Icons.image, size: 200, color: Colors.grey),

            const SizedBox(height: 12),

            // 공개 상태일 때만 제목/내용 보여줌
            if (isRevealed) ...[
              Text("제목: $title", style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              Text(content, style: const TextStyle(fontSize: 14)),
            ] else
              const Text(
                '(작성자가 아직 내용을 공개하지 않았어요)',
                style: TextStyle(fontSize: 16),
              ),

            const SizedBox(height: 12),

            // 공개 토글 버튼 (내가 쓴 글일 때만)
            if (isMyDiary && onToggleRevealed != null)
              ElevatedButton(
                onPressed: () {
                  print(
                    '🔁 [DiaryPageCard] onToggleRevealed 버튼 클릭됨 - diaryId: $diaryId',
                  );
                  onToggleRevealed!();
                },
                child: Text(isRevealed ? '숨기기' : '일기 공개'),
              ),

            // 마지막 페이지에 내 일기가 없으면 추가 버튼
            if (isLastPage && !isMyDiary && onAddPressed != null)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: ElevatedButton.icon(
                  onPressed: onAddPressed,
                  icon: const Icon(Icons.add),
                  label: const Text('그림일기 추가'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: OmmaColors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
