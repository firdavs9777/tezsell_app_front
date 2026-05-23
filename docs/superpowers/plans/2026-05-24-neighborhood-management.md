# Neighborhood Management Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace `/change-city` map flow with Karrot-style neighborhood management: AppBar chip → quick-switch bottom sheet; `/location/manage` map page with live GPS dot, verified-neighborhood pins, instant-switch chips, and "Verify here" FAB.

**Architecture:** Two new widgets (`NeighborhoodSwitcherSheet`, `NeighborhoodManagementPage`) replace `MapLocationFilterPage`. `NeighborhoodVerifier` is patched to use `addEvictingOldest()` and gains an `onDone` callback. All existing provider/verification infrastructure is reused unchanged.

**Tech Stack:** Flutter, Riverpod 2.x, flutter_map 6.2.1 + OpenStreetMap tiles, geolocator, go_router, existing `NeighborhoodVerifier` / `verifiedNeighborhoodsProvider` / `activeNeighborhoodIndexProvider`.

---

## Files

### Create
| File | Purpose |
|------|---------|
| `lib/widgets/maps/neighborhood_switcher_sheet.dart` | Quick-switch bottom sheet on AppBar chip tap |
| `lib/pages/location/neighborhood_management_page.dart` | Full map screen (GPS, pins, chips, FAB, verify flow) |

### Modify
| File | Change |
|------|--------|
| `lib/l10n/app_en.arb` (+ 14 others) | Add 12 neighborhood-management l10n keys |
| `lib/widgets/maps/neighborhood_verifier.dart` | Use `addEvictingOldest()`; add `onDone` callback |
| `lib/config/app_router.dart` | Add `/location/manage` route; redirect `/change-city` |
| `lib/pages/tab_bar/tab_bar.dart` | Chip tap → `showModalBottomSheet(NeighborhoodSwitcherSheet)` |
| `lib/pages/shaxsiy/shaxsiy.dart` | Location menu → `context.push('/location/manage')` |

### Delete
| File | Reason |
|------|--------|
| `lib/pages/change_city/map_location_filter.dart` | Fully replaced by `NeighborhoodManagementPage` |

---

## Task 1: l10n — Add neighborhood management strings to all 15 locales

**Files:**
- Modify: `lib/l10n/app_en.arb`
- Modify: `lib/l10n/app_ar.arb`, `app_de.arb`, `app_es.arb`, `app_fr.arb`, `app_hi.arb`, `app_id.arb`, `app_ja.arb`, `app_ko.arb`, `app_pt.arb`, `app_ru.arb`, `app_tr.arb`, `app_uz.arb`, `app_vi.arb`, `app_zh.arb`

- [ ] **Step 1: Add keys to `app_en.arb`**

Insert before the final `}` of the file (after the `radius_slider_km` block):

```json
  ,
  "my_neighborhoods": "My Neighborhoods",
  "@my_neighborhoods": {"description": "Title for the neighborhood switcher sheet"},
  "manage_on_map": "Manage on map",
  "@manage_on_map": {"description": "Button to open neighborhood map management page"},
  "no_neighborhoods_yet": "No verified neighborhoods yet. Open the map to verify where you are.",
  "@no_neighborhoods_yet": {"description": "Empty state in neighborhood switcher"},
  "open_map_to_verify": "Open map to verify new location",
  "@open_map_to_verify": {"description": "Button to open map for verifying a new neighborhood"},
  "verify_here": "Verify here",
  "@verify_here": {"description": "FAB label on neighborhood management map"},
  "verify_new_location": "Verify new location",
  "@verify_new_location": {"description": "Title of the eviction warning sheet"},
  "eviction_warning": "Adding this location will remove {name} (your oldest). This cannot be undone.",
  "@eviction_warning": {
    "description": "Warning shown when at max 2 neighborhoods",
    "placeholders": {"name": {"type": "String"}}
  },
  "verified_today": "Verified today",
  "@verified_today": {"description": "Subtitle when neighborhood was verified today"},
  "verified_yesterday": "Verified yesterday",
  "@verified_yesterday": {"description": "Subtitle when neighborhood was verified yesterday"},
  "verified_n_days_ago": "Verified {days} days ago",
  "@verified_n_days_ago": {
    "description": "Subtitle when neighborhood was verified N days ago",
    "placeholders": {"days": {"type": "int"}}
  },
  "active_neighborhood": "Active",
  "@active_neighborhood": {"description": "Label for the currently active neighborhood"},
  "switch_neighborhood_success": "Switched to {name}",
  "@switch_neighborhood_success": {
    "description": "Snackbar text after switching active neighborhood",
    "placeholders": {"name": {"type": "String"}}
  }
```

- [ ] **Step 2: Add translations to `app_ar.arb`** (insert before final `}`)

```json
  ,
  "my_neighborhoods": "أحيائي",
  "manage_on_map": "إدارة على الخريطة",
  "no_neighborhoods_yet": "لا توجد أحياء موثقة بعد. افتح الخريطة للتحقق من مكان وجودك.",
  "open_map_to_verify": "فتح الخريطة للتحقق من موقع جديد",
  "verify_here": "التحقق هنا",
  "verify_new_location": "التحقق من موقع جديد",
  "eviction_warning": "سيؤدي إضافة هذا الموقع إلى إزالة {name} (الأقدم). لا يمكن التراجع عن ذلك.",
  "verified_today": "تم التحقق اليوم",
  "verified_yesterday": "تم التحقق أمس",
  "verified_n_days_ago": "تم التحقق منذ {days} أيام",
  "active_neighborhood": "نشط",
  "switch_neighborhood_success": "تم التبديل إلى {name}"
```

- [ ] **Step 3: Add translations to `app_de.arb`** (insert before final `}`)

```json
  ,
  "my_neighborhoods": "Meine Stadtteile",
  "manage_on_map": "Auf Karte verwalten",
  "no_neighborhoods_yet": "Noch keine verifizierten Stadtteile. Öffne die Karte, um deinen Standort zu verifizieren.",
  "open_map_to_verify": "Karte öffnen, um neuen Standort zu verifizieren",
  "verify_here": "Hier verifizieren",
  "verify_new_location": "Neuen Standort verifizieren",
  "eviction_warning": "Das Hinzufügen dieses Standorts entfernt {name} (deinen ältesten). Dies kann nicht rückgängig gemacht werden.",
  "verified_today": "Heute verifiziert",
  "verified_yesterday": "Gestern verifiziert",
  "verified_n_days_ago": "Vor {days} Tagen verifiziert",
  "active_neighborhood": "Aktiv",
  "switch_neighborhood_success": "Zu {name} gewechselt"
```

- [ ] **Step 4: Add translations to `app_es.arb`** (insert before final `}`)

```json
  ,
  "my_neighborhoods": "Mis barrios",
  "manage_on_map": "Gestionar en mapa",
  "no_neighborhoods_yet": "Aún no hay barrios verificados. Abre el mapa para verificar dónde estás.",
  "open_map_to_verify": "Abrir mapa para verificar nueva ubicación",
  "verify_here": "Verificar aquí",
  "verify_new_location": "Verificar nueva ubicación",
  "eviction_warning": "Agregar esta ubicación eliminará {name} (el más antiguo). Esto no se puede deshacer.",
  "verified_today": "Verificado hoy",
  "verified_yesterday": "Verificado ayer",
  "verified_n_days_ago": "Verificado hace {days} días",
  "active_neighborhood": "Activo",
  "switch_neighborhood_success": "Cambiado a {name}"
```

- [ ] **Step 5: Add translations to `app_fr.arb`** (insert before final `}`)

```json
  ,
  "my_neighborhoods": "Mes quartiers",
  "manage_on_map": "Gérer sur la carte",
  "no_neighborhoods_yet": "Aucun quartier vérifié pour l'instant. Ouvrez la carte pour vérifier où vous êtes.",
  "open_map_to_verify": "Ouvrir la carte pour vérifier un nouveau lieu",
  "verify_here": "Vérifier ici",
  "verify_new_location": "Vérifier un nouveau lieu",
  "eviction_warning": "L'ajout de ce lieu supprimera {name} (votre plus ancien). Cette action est irréversible.",
  "verified_today": "Vérifié aujourd'hui",
  "verified_yesterday": "Vérifié hier",
  "verified_n_days_ago": "Vérifié il y a {days} jours",
  "active_neighborhood": "Actif",
  "switch_neighborhood_success": "Basculé vers {name}"
```

- [ ] **Step 6: Add translations to `app_hi.arb`** (insert before final `}`)

```json
  ,
  "my_neighborhoods": "मेरे मोहल्ले",
  "manage_on_map": "मानचित्र पर प्रबंधित करें",
  "no_neighborhoods_yet": "अभी तक कोई सत्यापित मोहल्ला नहीं है। जहाँ आप हैं उसे सत्यापित करने के लिए मानचित्र खोलें।",
  "open_map_to_verify": "नए स्थान को सत्यापित करने के लिए मानचित्र खोलें",
  "verify_here": "यहाँ सत्यापित करें",
  "verify_new_location": "नया स्थान सत्यापित करें",
  "eviction_warning": "इस स्थान को जोड़ने से {name} (सबसे पुराना) हट जाएगा। यह पूर्ववत नहीं किया जा सकता।",
  "verified_today": "आज सत्यापित",
  "verified_yesterday": "कल सत्यापित",
  "verified_n_days_ago": "{days} दिन पहले सत्यापित",
  "active_neighborhood": "सक्रिय",
  "switch_neighborhood_success": "{name} पर स्विच किया"
```

- [ ] **Step 7: Add translations to `app_id.arb`** (insert before final `}`)

```json
  ,
  "my_neighborhoods": "Lingkungan Saya",
  "manage_on_map": "Kelola di peta",
  "no_neighborhoods_yet": "Belum ada lingkungan yang terverifikasi. Buka peta untuk memverifikasi lokasi Anda.",
  "open_map_to_verify": "Buka peta untuk memverifikasi lokasi baru",
  "verify_here": "Verifikasi di sini",
  "verify_new_location": "Verifikasi lokasi baru",
  "eviction_warning": "Menambahkan lokasi ini akan menghapus {name} (yang terlama). Ini tidak dapat dibatalkan.",
  "verified_today": "Diverifikasi hari ini",
  "verified_yesterday": "Diverifikasi kemarin",
  "verified_n_days_ago": "Diverifikasi {days} hari yang lalu",
  "active_neighborhood": "Aktif",
  "switch_neighborhood_success": "Beralih ke {name}"
```

- [ ] **Step 8: Add translations to `app_ja.arb`** (insert before final `}`)

```json
  ,
  "my_neighborhoods": "マイエリア",
  "manage_on_map": "マップで管理",
  "no_neighborhoods_yet": "まだ認証済みのエリアがありません。マップを開いて現在地を認証してください。",
  "open_map_to_verify": "マップを開いて新しい場所を認証",
  "verify_here": "ここで認証",
  "verify_new_location": "新しい場所を認証",
  "eviction_warning": "この場所を追加すると{name}（最も古い場所）が削除されます。この操作は元に戻せません。",
  "verified_today": "今日認証済み",
  "verified_yesterday": "昨日認証済み",
  "verified_n_days_ago": "{days}日前に認証済み",
  "active_neighborhood": "アクティブ",
  "switch_neighborhood_success": "{name}に切り替えました"
```

- [ ] **Step 9: Add translations to `app_ko.arb`** (insert before final `}`)

```json
  ,
  "my_neighborhoods": "내 동네",
  "manage_on_map": "지도에서 관리",
  "no_neighborhoods_yet": "아직 인증된 동네가 없습니다. 지도를 열어 현재 위치를 인증하세요.",
  "open_map_to_verify": "지도 열어 새 위치 인증",
  "verify_here": "여기서 인증",
  "verify_new_location": "새 위치 인증",
  "eviction_warning": "이 위치를 추가하면 {name}(가장 오래된 동네)이 삭제됩니다. 이 작업은 취소할 수 없습니다.",
  "verified_today": "오늘 인증됨",
  "verified_yesterday": "어제 인증됨",
  "verified_n_days_ago": "{days}일 전 인증됨",
  "active_neighborhood": "활성",
  "switch_neighborhood_success": "{name}(으)로 전환되었습니다"
```

- [ ] **Step 10: Add translations to `app_pt.arb`** (insert before final `}`)

```json
  ,
  "my_neighborhoods": "Meus bairros",
  "manage_on_map": "Gerenciar no mapa",
  "no_neighborhoods_yet": "Ainda não há bairros verificados. Abra o mapa para verificar onde você está.",
  "open_map_to_verify": "Abrir mapa para verificar novo local",
  "verify_here": "Verificar aqui",
  "verify_new_location": "Verificar novo local",
  "eviction_warning": "Adicionar este local removerá {name} (o mais antigo). Isso não pode ser desfeito.",
  "verified_today": "Verificado hoje",
  "verified_yesterday": "Verificado ontem",
  "verified_n_days_ago": "Verificado há {days} dias",
  "active_neighborhood": "Ativo",
  "switch_neighborhood_success": "Alternado para {name}"
```

- [ ] **Step 11: Add translations to `app_ru.arb`** (insert before final `}`)

```json
  ,
  "my_neighborhoods": "Мои районы",
  "manage_on_map": "Управление на карте",
  "no_neighborhoods_yet": "Нет подтверждённых районов. Откройте карту, чтобы подтвердить своё местоположение.",
  "open_map_to_verify": "Открыть карту для подтверждения нового места",
  "verify_here": "Подтвердить здесь",
  "verify_new_location": "Подтвердить новое место",
  "eviction_warning": "Добавление этого места удалит {name} (ваш самый старый район). Это действие нельзя отменить.",
  "verified_today": "Подтверждено сегодня",
  "verified_yesterday": "Подтверждено вчера",
  "verified_n_days_ago": "Подтверждено {days} дней назад",
  "active_neighborhood": "Активный",
  "switch_neighborhood_success": "Переключено на {name}"
```

- [ ] **Step 12: Add translations to `app_tr.arb`** (insert before final `}`)

```json
  ,
  "my_neighborhoods": "Mahallelerim",
  "manage_on_map": "Haritada yönet",
  "no_neighborhoods_yet": "Henüz doğrulanmış mahalle yok. Nerede olduğunuzu doğrulamak için haritayı açın.",
  "open_map_to_verify": "Yeni konumu doğrulamak için haritayı açın",
  "verify_here": "Burayı doğrula",
  "verify_new_location": "Yeni konumu doğrula",
  "eviction_warning": "Bu konum eklendiğinde {name} (en eskisi) kaldırılacaktır. Bu işlem geri alınamaz.",
  "verified_today": "Bugün doğrulandı",
  "verified_yesterday": "Dün doğrulandı",
  "verified_n_days_ago": "{days} gün önce doğrulandı",
  "active_neighborhood": "Aktif",
  "switch_neighborhood_success": "{name} konumuna geçildi"
```

- [ ] **Step 13: Add translations to `app_uz.arb`** (insert before final `}`)

```json
  ,
  "my_neighborhoods": "Mening mahallalarim",
  "manage_on_map": "Xaritada boshqarish",
  "no_neighborhoods_yet": "Hali tasdiqlanган mahallalar yo'q. Joylashuvingizni tasdiqlash uchun xaritani oching.",
  "open_map_to_verify": "Yangi joylashuvni tasdiqlash uchun xaritani oching",
  "verify_here": "Bu yerda tasdiqlash",
  "verify_new_location": "Yangi joylashuvni tasdiqlash",
  "eviction_warning": "Bu joylashuvni qo'shish {name} (eng eski)ni o'chiradi. Bu amal bekor qilib bo'lmaydi.",
  "verified_today": "Bugun tasdiqlangan",
  "verified_yesterday": "Kecha tasdiqlangan",
  "verified_n_days_ago": "{days} kun oldin tasdiqlangan",
  "active_neighborhood": "Faol",
  "switch_neighborhood_success": "{name}ga o'tildi"
```

- [ ] **Step 14: Add translations to `app_vi.arb`** (insert before final `}`)

```json
  ,
  "my_neighborhoods": "Khu phố của tôi",
  "manage_on_map": "Quản lý trên bản đồ",
  "no_neighborhoods_yet": "Chưa có khu phố nào được xác minh. Mở bản đồ để xác minh vị trí của bạn.",
  "open_map_to_verify": "Mở bản đồ để xác minh vị trí mới",
  "verify_here": "Xác minh tại đây",
  "verify_new_location": "Xác minh vị trí mới",
  "eviction_warning": "Thêm vị trí này sẽ xóa {name} (cũ nhất của bạn). Không thể hoàn tác.",
  "verified_today": "Đã xác minh hôm nay",
  "verified_yesterday": "Đã xác minh hôm qua",
  "verified_n_days_ago": "Đã xác minh {days} ngày trước",
  "active_neighborhood": "Đang hoạt động",
  "switch_neighborhood_success": "Đã chuyển sang {name}"
```

- [ ] **Step 15: Add translations to `app_zh.arb`** (insert before final `}`)

```json
  ,
  "my_neighborhoods": "我的社区",
  "manage_on_map": "在地图上管理",
  "no_neighborhoods_yet": "尚无已验证的社区。打开地图验证您所在的位置。",
  "open_map_to_verify": "打开地图验证新位置",
  "verify_here": "在此验证",
  "verify_new_location": "验证新位置",
  "eviction_warning": "添加此位置将删除{name}（最早的）。此操作无法撤消。",
  "verified_today": "今天已验证",
  "verified_yesterday": "昨天已验证",
  "verified_n_days_ago": "{days}天前已验证",
  "active_neighborhood": "活跃",
  "switch_neighborhood_success": "已切换到{name}"
```

- [ ] **Step 16: Regenerate and verify**

```bash
cd /Users/firdavsmutalipov/Desktop/Sabzi_Market/app && flutter gen-l10n
```

Expected: exits 0. Then verify:

```bash
grep -c "my_neighborhoods\|verify_here\|eviction_warning\|verified_today\|verified_n_days_ago\|switch_neighborhood_success" lib/l10n/app_localizations.dart
```

Expected: ≥ 6 lines (one method signature per key at minimum).

- [ ] **Step 17: Commit**

```bash
git add lib/l10n/
git commit -m "feat(l10n): add 12 neighborhood-management strings to all 15 locales"
```

---

## Task 2: Patch NeighborhoodVerifier — use addEvictingOldest() + onDone callback

**Files:**
- Modify: `lib/widgets/maps/neighborhood_verifier.dart`

- [ ] **Step 1: Add `onDone` parameter to the widget**

In `lib/widgets/maps/neighborhood_verifier.dart`, change the class definition and constructor from:

```dart
class NeighborhoodVerifier extends ConsumerStatefulWidget {
  /// Optional pre-resolved Position to skip GPS read (used by integration tests).
  final Position? injectedPosition;
  ...
  const NeighborhoodVerifier({super.key, this.injectedPosition});
```

to:

```dart
class NeighborhoodVerifier extends ConsumerStatefulWidget {
  /// Optional pre-resolved Position to skip GPS read (used by integration tests).
  final Position? injectedPosition;

  /// Called when verification succeeds (stage transitions to done).
  final VoidCallback? onDone;

  ...
  const NeighborhoodVerifier({super.key, this.injectedPosition, this.onDone});
```

- [ ] **Step 2: Change `add()` to `addEvictingOldest()` in `_confirm()`**

In `_confirm()` at line 122, change:

```dart
      await ref.read(verifiedNeighborhoodsProvider.notifier).add(
```

to:

```dart
      await ref.read(verifiedNeighborhoodsProvider.notifier).addEvictingOldest(
```

- [ ] **Step 3: Call `onDone` when verification succeeds**

In `_confirm()`, after `setState(() { _resolved = serverNeighborhood; _stage = _Stage.done; });`, add:

```dart
      setState(() {
        _resolved = serverNeighborhood;
        _stage = _Stage.done;
      });
      widget.onDone?.call();
```

- [ ] **Step 4: Run flutter analyze**

```bash
cd /Users/firdavsmutalipov/Desktop/Sabzi_Market/app && flutter analyze lib/widgets/maps/neighborhood_verifier.dart
```

Expected: `No issues found!`

- [ ] **Step 5: Commit**

```bash
git add lib/widgets/maps/neighborhood_verifier.dart
git commit -m "feat(verifier): use addEvictingOldest() and expose onDone callback"
```

---

## Task 3: Create NeighborhoodSwitcherSheet widget

**Files:**
- Create: `lib/widgets/maps/neighborhood_switcher_sheet.dart`

- [ ] **Step 1: Create the file**

```dart
import 'package:app/l10n/app_localizations.dart';
import 'package:app/providers/provider_root/active_neighborhood_provider.dart';
import 'package:app/providers/provider_root/product_provider.dart';
import 'package:app/providers/provider_root/service_provider.dart';
import 'package:app/providers/provider_root/verified_neighborhoods_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class NeighborhoodSwitcherSheet extends ConsumerWidget {
  const NeighborhoodSwitcherSheet({super.key});

  String _displayName(neighborhood) {
    return neighborhood.city.isNotEmpty ? neighborhood.city : neighborhood.name;
  }

  String _verifiedLabel(AppLocalizations? l, DateTime verifiedAt) {
    final days = DateTime.now().difference(verifiedAt).inDays;
    if (days == 0) return l?.verified_today ?? 'Verified today';
    if (days == 1) return l?.verified_yesterday ?? 'Verified yesterday';
    return l?.verified_n_days_ago(days) ?? 'Verified $days days ago';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final verified = ref.watch(verifiedNeighborhoodsProvider);
    final activeIdx = ref.watch(activeNeighborhoodIndexProvider);

    void switchTo(int idx) {
      ref.read(activeNeighborhoodIndexProvider.notifier).state = idx;
      ref.invalidate(productsProvider);
      ref.invalidate(servicesProvider);
      Navigator.of(context).pop();
    }

    void openMap() {
      final router = GoRouter.of(context);
      Navigator.of(context).pop();
      router.push('/location/manage');
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 32,
                height: 4,
                decoration: BoxDecoration(
                  color: cs.onSurfaceVariant.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Title row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l?.my_neighborhoods ?? 'My Neighborhoods',
                  style: tt.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: openMap,
                  child: Text(l?.manage_on_map ?? 'Manage on map →'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (verified.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  children: [
                    Text(
                      l?.no_neighborhoods_yet ??
                          'No verified neighborhoods yet. Open the map to verify where you are.',
                      textAlign: TextAlign.center,
                      style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
                    ),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: openMap,
                      child: Text(l?.open_map_to_verify ?? 'Open map'),
                    ),
                  ],
                ),
              )
            else
              ...List.generate(verified.length, (i) {
                final v = verified[i];
                final isActive = i == activeIdx;
                final name = _displayName(v.neighborhood);
                return ListTile(
                  tileColor: isActive
                      ? cs.primaryContainer.withValues(alpha: 0.15)
                      : null,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  leading: CircleAvatar(
                    backgroundColor: isActive
                        ? cs.primaryContainer
                        : cs.surfaceContainerHighest,
                    child: Text(
                      name.isNotEmpty ? name[0].toUpperCase() : '?',
                      style: TextStyle(
                        color: isActive
                            ? cs.onPrimaryContainer
                            : cs.onSurfaceVariant,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    name,
                    style: TextStyle(
                        fontWeight:
                            isActive ? FontWeight.bold : FontWeight.normal),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    _verifiedLabel(l, v.verifiedAt),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: isActive
                      ? Icon(Icons.check_circle_rounded, color: cs.primary)
                      : null,
                  onTap: () => switchTo(i),
                );
              }),
            const SizedBox(height: 12),
            if (verified.isNotEmpty)
              OutlinedButton.icon(
                onPressed: openMap,
                icon: const Icon(Icons.map_outlined),
                label: Text(
                  l?.open_map_to_verify ?? 'Open map to verify new location',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 2: Run flutter analyze**

```bash
cd /Users/firdavsmutalipov/Desktop/Sabzi_Market/app && flutter analyze lib/widgets/maps/neighborhood_switcher_sheet.dart
```

Expected: `No issues found!`

- [ ] **Step 3: Commit**

```bash
git add lib/widgets/maps/neighborhood_switcher_sheet.dart
git commit -m "feat(location): add NeighborhoodSwitcherSheet bottom sheet"
```

---

## Task 4: Create NeighborhoodManagementPage

**Files:**
- Create: `lib/pages/location/neighborhood_management_page.dart`

- [ ] **Step 1: Create `lib/pages/location/` directory and the page file**

```dart
import 'dart:async';

import 'package:app/l10n/app_localizations.dart';
import 'package:app/providers/provider_models/neighborhood.dart';
import 'package:app/providers/provider_root/active_neighborhood_provider.dart';
import 'package:app/providers/provider_root/maps_provider_provider.dart';
import 'package:app/providers/provider_root/product_provider.dart';
import 'package:app/providers/provider_root/service_provider.dart';
import 'package:app/providers/provider_root/verified_neighborhoods_provider.dart';
import 'package:app/widgets/maps/neighborhood_verifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class NeighborhoodManagementPage extends ConsumerStatefulWidget {
  const NeighborhoodManagementPage({super.key});

  @override
  ConsumerState<NeighborhoodManagementPage> createState() =>
      _NeighborhoodManagementPageState();
}

class _NeighborhoodManagementPageState
    extends ConsumerState<NeighborhoodManagementPage> {
  final _mapController = MapController();
  StreamSubscription<Position>? _positionSub;
  Position? _currentPosition;
  bool _cameraFitted = false;

  @override
  void initState() {
    super.initState();
    _initGps();
  }

  @override
  void dispose() {
    _positionSub?.cancel();
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _initGps() async {
    var perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
    }
    if (perm == LocationPermission.denied ||
        perm == LocationPermission.deniedForever) {
      return;
    }

    final last = await Geolocator.getLastKnownPosition();
    if (last != null && mounted) {
      setState(() => _currentPosition = last);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_cameraFitted) {
          _fitCamera();
          _cameraFitted = true;
        }
      });
    }

    _positionSub = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high),
    ).listen((pos) {
      if (!mounted) return;
      setState(() => _currentPosition = pos);
      if (!_cameraFitted) {
        _fitCamera();
        _cameraFitted = true;
      }
    });
  }

  void _fitCamera() {
    final verified = ref.read(verifiedNeighborhoodsProvider);
    final points = <LatLng>[];
    if (_currentPosition != null) {
      points.add(
          LatLng(_currentPosition!.latitude, _currentPosition!.longitude));
    }
    for (final v in verified) {
      points.add(LatLng(v.neighborhood.centroidLat, v.neighborhood.centroidLng));
    }
    if (points.isEmpty) return;
    if (points.length == 1) {
      _mapController.move(points.first, 13);
      return;
    }
    _mapController.fitCamera(
      CameraFit.bounds(
        bounds: LatLngBounds.fromPoints(points),
        padding: const EdgeInsets.all(60),
      ),
    );
  }

  LatLng _initialCenter() {
    final verified = ref.read(verifiedNeighborhoodsProvider);
    if (verified.isNotEmpty) {
      final idx = ref
          .read(activeNeighborhoodIndexProvider)
          .clamp(0, verified.length - 1);
      return LatLng(
        verified[idx].neighborhood.centroidLat,
        verified[idx].neighborhood.centroidLng,
      );
    }
    return const LatLng(20.0, 0.0);
  }

  void _switchTo(int idx) {
    ref.read(activeNeighborhoodIndexProvider.notifier).state = idx;
    ref.invalidate(productsProvider);
    ref.invalidate(servicesProvider);
  }

  Future<void> _onVerifyHere() async {
    final perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied ||
        perm == LocationPermission.deniedForever) {
      if (!mounted) return;
      final l = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(l?.location_permission_denied_settings ??
            'Location permission denied — please enable in Settings'),
        action: SnackBarAction(
          label: 'Settings',
          onPressed: Geolocator.openAppSettings,
        ),
      ));
      return;
    }
    final verified = ref.read(verifiedNeighborhoodsProvider);
    if (verified.length < VerifiedNeighborhoodsNotifier.maxCount) {
      _startVerification();
    } else {
      final oldest = verified.reduce(
          (a, b) => a.verifiedAt.isBefore(b.verifiedAt) ? a : b);
      _showEvictionWarning(oldest);
    }
  }

  void _showEvictionWarning(VerifiedNeighborhood oldest) {
    final l = AppLocalizations.of(context);
    final name = oldest.neighborhood.city.isNotEmpty
        ? oldest.neighborhood.city
        : oldest.neighborhood.name;
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        final cs = Theme.of(ctx).colorScheme;
        return Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(24, 16, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 32,
                  height: 4,
                  decoration: BoxDecoration(
                    color: cs.onSurfaceVariant.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                l?.verify_new_location ?? 'Verify new location',
                style: Theme.of(ctx)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: cs.errorContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  l?.eviction_warning(name) ??
                      'Adding this location will remove $name (your oldest). This cannot be undone.',
                  style: TextStyle(color: cs.onErrorContainer),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: Text(l?.cancel ?? 'Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        _startVerification();
                      },
                      child: Text(l?.verify_here ?? 'Verify'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _startVerification() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: NeighborhoodVerifier(
          onDone: () => Navigator.of(ctx).pop(),
        ),
      ),
    ).then((_) {
      if (!mounted) return;
      final verified = ref.read(verifiedNeighborhoodsProvider);
      if (verified.isNotEmpty) {
        ref.read(activeNeighborhoodIndexProvider.notifier).state =
            verified.length - 1;
      }
      ref.invalidate(productsProvider);
      ref.invalidate(servicesProvider);
      // Fit camera to include new neighborhood pin
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _fitCamera());
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final mapsProvider = ref.watch(mapsProviderProvider);
    final verified = ref.watch(verifiedNeighborhoodsProvider);
    final activeIdx = ref.watch(activeNeighborhoodIndexProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l?.my_neighborhoods ?? 'My Neighborhoods'),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _initialCenter(),
              initialZoom: 13,
            ),
            children: [
              TileLayer(
                urlTemplate: mapsProvider.tileUrlTemplate,
                userAgentPackageName: mapsProvider.userAgent,
              ),
              if (_currentPosition != null) ...[
                CircleLayer(
                  circles: [
                    CircleMarker(
                      point: LatLng(_currentPosition!.latitude,
                          _currentPosition!.longitude),
                      radius: _currentPosition!.accuracy,
                      useRadiusInMeter: true,
                      color: Colors.blue.withValues(alpha: 0.12),
                      borderColor: Colors.blue.withValues(alpha: 0.4),
                      borderStrokeWidth: 1,
                    ),
                  ],
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: LatLng(_currentPosition!.latitude,
                          _currentPosition!.longitude),
                      width: 18,
                      height: 18,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue,
                          border:
                              Border.all(color: Colors.white, width: 2),
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.black26,
                                blurRadius: 3,
                                offset: Offset(0, 1))
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              if (verified.isNotEmpty)
                MarkerLayer(
                  markers: List.generate(verified.length, (i) {
                    final v = verified[i];
                    return Marker(
                      point: LatLng(v.neighborhood.centroidLat,
                          v.neighborhood.centroidLng),
                      width: 120,
                      height: 60,
                      alignment: Alignment.bottomCenter,
                      child: GestureDetector(
                        onTap: () => _switchTo(i),
                        child: _NeighborhoodPin(
                          neighborhood: v,
                          isActive: i == activeIdx,
                        ),
                      ),
                    );
                  }),
                ),
              SimpleAttributionWidget(
                source: const Text('© OpenStreetMap contributors'),
              ),
            ],
          ),
          // Floating chips bar
          if (verified.isNotEmpty)
            Positioned(
              top: 12,
              left: 12,
              right: 12,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List.generate(verified.length, (i) {
                  return _NeighborhoodChip(
                    neighborhood: verified[i],
                    isActive: i == activeIdx,
                    onTap: () => _switchTo(i),
                  );
                }),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _onVerifyHere,
        icon: const Icon(Icons.my_location_rounded),
        label: Text(l?.verify_here ?? 'Verify here'),
      ),
    );
  }
}

class _NeighborhoodPin extends StatelessWidget {
  final VerifiedNeighborhood neighborhood;
  final bool isActive;

  const _NeighborhoodPin({
    required this.neighborhood,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final raw = neighborhood.neighborhood.city.isNotEmpty
        ? neighborhood.neighborhood.city
        : neighborhood.neighborhood.name;
    final label = raw.length > 18 ? '${raw.substring(0, 18)}…' : raw;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding:
              const EdgeInsetsDirectional.fromSTEB(6, 3, 6, 3),
          decoration: BoxDecoration(
            color: isActive ? cs.primary : cs.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black26,
                  blurRadius: 2,
                  offset: Offset(0, 1))
            ],
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.white : cs.onSurface,
              fontSize: 11,
              fontWeight:
                  isActive ? FontWeight.bold : FontWeight.normal,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Icon(
          Icons.location_on_rounded,
          size: 28,
          color: isActive ? cs.primary : cs.outline,
        ),
      ],
    );
  }
}

class _NeighborhoodChip extends StatelessWidget {
  final VerifiedNeighborhood neighborhood;
  final bool isActive;
  final VoidCallback onTap;

  const _NeighborhoodChip({
    required this.neighborhood,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final name = neighborhood.neighborhood.city.isNotEmpty
        ? neighborhood.neighborhood.city
        : neighborhood.neighborhood.name;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 140),
        padding: const EdgeInsetsDirectional.fromSTEB(12, 6, 12, 6),
        decoration: BoxDecoration(
          color: isActive ? cs.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: isActive ? cs.primary : cs.outline),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 4,
                offset: const Offset(0, 2))
          ],
        ),
        child: Text(
          name,
          style: TextStyle(
            color: isActive ? Colors.white : cs.onSurface,
            fontWeight:
                isActive ? FontWeight.bold : FontWeight.normal,
            fontSize: 12,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
```

- [ ] **Step 2: Run flutter analyze**

```bash
cd /Users/firdavsmutalipov/Desktop/Sabzi_Market/app && flutter analyze lib/pages/location/neighborhood_management_page.dart
```

Expected: `No issues found!`

- [ ] **Step 3: Commit**

```bash
git add lib/pages/location/
git commit -m "feat(location): add NeighborhoodManagementPage with GPS, pins, chips, FAB"
```

---

## Task 5: Update app_router.dart — add /location/manage, redirect /change-city

**Files:**
- Modify: `lib/config/app_router.dart`

- [ ] **Step 1: Add import for NeighborhoodManagementPage**

In `lib/config/app_router.dart`, after the existing imports section (around line 44 after the onboarding import), add:

```dart
import '../pages/location/neighborhood_management_page.dart';
```

- [ ] **Step 2: Add `/location/manage` route**

In `lib/config/app_router.dart`, find the `/change-city` route block:

```dart
      GoRoute(
        path: '/change-city',
        name: 'change-city',
        builder: (context, state) => const MapLocationFilterPage(),
      ),
```

Replace it with:

```dart
      GoRoute(
        path: '/location/manage',
        name: 'location-manage',
        builder: (context, state) => const NeighborhoodManagementPage(),
      ),
      GoRoute(
        path: '/change-city',
        name: 'change-city',
        redirect: (_, __) => '/location/manage',
      ),
```

- [ ] **Step 3: Remove the MapLocationFilterPage import**

Remove line 38:

```dart
import '../pages/change_city/map_location_filter.dart';
```

- [ ] **Step 4: Run flutter analyze**

```bash
cd /Users/firdavsmutalipov/Desktop/Sabzi_Market/app && flutter analyze lib/config/app_router.dart
```

Expected: `No issues found!`

- [ ] **Step 5: Commit**

```bash
git add lib/config/app_router.dart
git commit -m "feat(router): add /location/manage route; redirect /change-city"
```

---

## Task 6: Update tab_bar.dart — chip tap opens NeighborhoodSwitcherSheet

**Files:**
- Modify: `lib/pages/tab_bar/tab_bar.dart`

- [ ] **Step 1: Add NeighborhoodSwitcherSheet import**

In `lib/pages/tab_bar/tab_bar.dart`, after the existing `neighborhood_verifier.dart` import (line 13), add:

```dart
import 'package:app/widgets/maps/neighborhood_switcher_sheet.dart';
```

- [ ] **Step 2: Change the chip's `onTap` from `_navigateToLocationChange` to bottom sheet**

In `_buildLocationChip`, change:

```dart
    return GestureDetector(
      onTap: _navigateToLocationChange,
```

to:

```dart
    return GestureDetector(
      onTap: () => showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (_) => const NeighborhoodSwitcherSheet(),
      ),
```

- [ ] **Step 3: Run flutter analyze**

```bash
cd /Users/firdavsmutalipov/Desktop/Sabzi_Market/app && flutter analyze lib/pages/tab_bar/tab_bar.dart
```

Expected: `No issues found!`

- [ ] **Step 4: Commit**

```bash
git add lib/pages/tab_bar/tab_bar.dart
git commit -m "feat(tabbar): location chip tap opens NeighborhoodSwitcherSheet"
```

---

## Task 7: Update shaxsiy.dart + delete map_location_filter.dart

**Files:**
- Modify: `lib/pages/shaxsiy/shaxsiy.dart`
- Delete: `lib/pages/change_city/map_location_filter.dart`

- [ ] **Step 1: Update location menu item in shaxsiy.dart**

In `lib/pages/shaxsiy/shaxsiy.dart`, find the location `ProfileMenuCard` (line ~278):

```dart
                    onTap: () => context.push('/change-city'),
```

Change to:

```dart
                    onTap: () => context.push('/location/manage'),
```

- [ ] **Step 2: Delete map_location_filter.dart**

```bash
rm /Users/firdavsmutalipov/Desktop/Sabzi_Market/app/lib/pages/change_city/map_location_filter.dart
```

- [ ] **Step 3: Run flutter analyze across the whole project**

```bash
cd /Users/firdavsmutalipov/Desktop/Sabzi_Market/app && flutter analyze
```

Expected: `No issues found!`

- [ ] **Step 4: Commit**

```bash
git add lib/pages/shaxsiy/shaxsiy.dart
git rm lib/pages/change_city/map_location_filter.dart
git commit -m "feat(profile): location menu opens /location/manage; remove MapLocationFilterPage"
```

---

## Completion checklist

After all 7 tasks:

- [ ] `flutter analyze` passes with no issues
- [ ] AppBar location chip tap opens bottom sheet (not a full-screen push)
- [ ] Switching neighborhood in sheet instantly refreshes product/service feeds
- [ ] "Manage on map" → pushes `/location/manage`
- [ ] Map shows GPS blue dot + accuracy ring when permission granted
- [ ] Verified neighborhood pins tap-to-switch works
- [ ] Floating chips bar switches active neighborhood
- [ ] "Verify here" FAB with 0–1 neighborhoods → opens verifier directly
- [ ] "Verify here" FAB with 2 neighborhoods → shows eviction warning first
- [ ] After verification, new neighborhood becomes active and map camera refits
- [ ] `/change-city` deep links redirect to `/location/manage` (no crash)
- [ ] Profile → Location → pushes `/location/manage`
- [ ] All 15 locales compile without l10n errors
