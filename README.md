# CartDash MVP - E-commerce Cart with Optimistic UI

## Overview

**CartDash** is a production-grade Flutter e-commerce cart application showcasing **optimistic UI patterns** and **rollback handling**. Users experience instant feedback when adding/removing items, with silent background synchronization and graceful error recovery.

---

##  Key Features

### Optimistic UI Updates
- **Instant feedback** when users interact with the cart
- Cart updates appear immediately while API calls happen in the background
- Smooth animations for quantity changes and price updates

### Automatic Rollback
- If a server request fails (e.g., item out of stock), the UI automatically reverts
- Error messages guide users on what went wrong
- No broken or confused state

### Demo Control Panel
- **Network Latency Slider**: Simulate 0ms–3000ms delays
- **Force Failure Toggle**: Test rollback behavior without real failures
- Perfect for presentations and demonstrations

### Polished UX
- Animated quantity counters (scale transition)
- Floating checkout bar with animated totals
- Bottom sheet error notifications with haptic feedback
- Responsive product cards

---

##  Architecture

### Clean Architecture Layers

```
Presentation Layer (Widgets + BloC)
        ↓
Domain Layer (Models & Entities)
        ↓
Data Layer (API Service & Repositories)
```

### State Management: flutter_bloc
- `CartEvent`: User actions (add, increment, decrement, remove)
- `CartState`: UI states (Initial, Loading, Updated, Error)
- `CartBloc`: Business logic with rollback snapshots

### Optimistic UI Flow
```
[User Click] → [Emit Optimistic State] → [UI Updates] → [Background API Call] 
    ↓
[Success] → [Confirm State] OR [Failure] → [Emit Rollback State + Error Message]
```

---

##  Project Structure

```
cartdash_mvp/
├── lib/
│   ├── main.dart                           # App entry point
│   ├── domain/
│   │   ├── entities/
│   │   │   └── cart_item.dart             # CartItem data model
│   │   └── models/
│   │       ├── cart_event.dart            # BloC events
│   │       └── cart_state.dart            # BloC states
│   ├── data/
│   │   └── services/
│   │       └── api_service.dart           # API calls + demo controls
│   ├── presentation/
│   │   ├── bloc/
│   │   │   └── cart_bloc.dart             # Core business logic
│   │   ├── screens/
│   │   │   └── cart_screen.dart           # Main UI screen
│   │   └── widgets/
│   │       ├── animated_quantity_badge.dart    # Quantity counter
│   │       ├── cart_item_card.dart             # Item display
│   │       ├── floating_checkout_bar.dart      # Bottom checkout bar
│   │       ├── rollback_error_sheet.dart       # Error modal
│   │       └── demo_control_panel.dart         # Demo controls
│   └── utils/                              # Helpers & constants
├── pubspec.yaml                            # Dependencies
├── analysis_options.yaml                   # Lint rules
└── README.md                               # This file
```

---

##  Getting Started

### Prerequisites
- Flutter SDK 3.0+
- Dart 3.0+

### Installation

1. **Navigate to project**
   ```bash
   cd cartdash_mvp
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

---

## 🎮 Using the Demo

### 1. **Add Items to Cart**
- Tap "Add" on any product
- Watch the item appear instantly in the cart
- Observe the floating checkout bar update in real-time

### 2. **Adjust Quantities**
- Use +/− buttons in cart items
- Quantities animate smoothly
- Total price updates dynamically

### 3. **Test with Demo Controls**
- **Network Latency Slider**: Set to 2000ms to see the background sync
- **Force Failure Toggle**: Turn ON to simulate server rejections
  - Try adding an item
  - Watch it appear instantly
  - After 2 seconds, it reverts and shows an error

### 4. **Trigger Rollback**
```
1. Enable "Force Out of Stock Failure"
2. Set latency to 1500ms for visibility
3. Click "Add" on any product
4. Watch cart update instantly
5. After delay, see the smooth rollback + error modal
6. Cart returns to previous state
```

---

##  Core Technical Details

### CartBloc Optimistic Pattern

```dart
// 1. Save current state (for rollback)
final previousItems = List<CartItem>.from(currentState.items);

// 2. Compute new state optimistically
final updatedItems = [...];

// 3. IMMEDIATELY emit to UI
emit(CartUpdated(items: updatedItems, ...));

// 4. Fire background request
final response = await apiService.reserveInventory(...);

// 5. Handle result
if (response.isSuccess) {
  emit(CartUpdated(items: updatedItems, ...)); // Confirm
} else {
  emit(CartUpdated(items: previousItems, errorMessage: ...)); // Rollback
}
```

### Animated Total Price

Uses `TweenAnimationBuilder` for smooth number transitions:
```dart
TweenAnimationBuilder<double>(
  tween: Tween<double>(begin: 0, end: totalPrice),
  duration: const Duration(milliseconds: 250),
  builder: (context, value, child) {
    return Text('\$${value.toStringAsFixed(2)}');
  },
);
```

### Quantity Counter Scaling

`AnimatedSwitcher` scales numbers up/down when quantity changes:
```dart
AnimatedSwitcher(
  transitionBuilder: (child, animation) {
    return ScaleTransition(scale: animation, child: child);
  },
  child: Text('$quantity', key: ValueKey(quantity)),
);
```

---

##  Dependencies

| Package | Purpose |
|---------|---------|
| `flutter_bloc` | State management & business logic |
| `bloc` | Core BloC library |
| `dio` | HTTP client (extensible for real APIs) |
| `equatable` | Value equality for models |
| `hive` | Local caching (optional upgrade) |

---

## 🎓 Learning Outcomes

After studying CartDash, you'll understand:

 **Optimistic UI patterns** used by Google, Notion, Trello  
 **BloC architecture** for complex state management  
 **Rollback strategies** when network requests fail  
 **Smooth animations** in Flutter  
 **Error recovery** with UX-first thinking  
 **Clean architecture** principles  

---

## Potential Upgrades

### Phase 2: Persistence
- Add **Hive local database** to persist cart across sessions
- Implement cart recovery on app restart

### Phase 3: Real Backend
- Replace mock API with real Firebase/REST endpoints
- Add user authentication
- Sync cart across devices

### Phase 4: Advanced Features
- Cart item filtering & sorting
- Wishlist functionality
- Discount codes & promo calculations
- Order history

### Phase 5: Production Polish
- Offline mode with queue-based sync
- Conflict resolution (edits from multiple devices)
- Performance optimizations
- Analytics tracking

---

## Demo Checklist

Use this before presenting:

- [ ] Set latency to **2000ms**
- [ ] Enable **Force Failure** toggle
- [ ] Add multiple items
- [ ] Watch instant UI updates
- [ ] Wait for auto-rollback
- [ ] Show error bottom sheet
- [ ] Disable failure, try again
- [ ] Show smooth checkout bar animation
- [ ] Demonstrate quantity increment/decrement

---

## Contributing

This is an MVP/portfolio project. Feel free to fork, enhance, and customize!

---

## License

MIT License - Free to use and modify

---

## Key Insights

**Why Optimistic UI matters:**
- Users expect instant feedback (modern web/apps set this expectation)
- Network delays are invisible; the app feels infinitely fast
- Errors are handled gracefully, not destructively
- This pattern is used by every major productivity app

**Why rollbacks are critical:**
- Not all operations succeed
- Users must trust the app to handle failures
- Clear error messages + automatic recovery build confidence
- Testing the failure path is as important as the happy path

---


