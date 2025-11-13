# Pemrograman Asynchronous

## Practicum 1

- **Question 1 :** 
![alt text](img/Question1.png)

- **Question 2 :**
![alt text](img/Question2.png)

- **Question 3 :**
- - Explain the meaning of step 5 regarding substring and catchError!
The onPressed code in the ElevatedButton is used to fetch data asynchronously when the button is pressed. The getData() function is executed, and if it succeeds, the response body is converted to a string and trimmed using substring(0, 450) to display only the first 450 characters, preventing the UI from being overloaded with long text. Then, setState() is called to update the UI with the fetched result. If an error occurs, for example due to a failed connection or if the string is shorter than 450 characters, catchError catches the exception and assigns the message 'An error occurred' to the result variable, followed by another setState() call to update the UI with the error message. This ensures that partial data is displayed when successful and that the app does not crash when an error occurs.

![alt text](img/Question3.gif)

## Practicum 2

### Explanation of Steps 1 and 2 
**Question 4**

**Step 1: Three Async Methods**
```dart
Future<int> returnOneAsync() async {
  await Future.delayed(const Duration(seconds: 3));
  return 1;
}

Future<int> returnTwoAsync() async {
  await Future.delayed(const Duration(seconds: 3));
  return 2;
}

Future<int> returnThreeAsync() async {
  await Future.delayed(const Duration(seconds: 3));
  return 3;
}
```
These three methods demonstrate asynchronous operations in Flutter/Dart:
1. Each method returns a `Future<int>`, indicating an async operation that will produce an integer value
2. The `async` keyword marks these methods as asynchronous
3. `Future.delayed()` simulates a time-consuming process (3-second delay)
4. After the delay, each method returns a different number (1, 2, and 3)

**Step 2: count() Method**
```dart
Future<void> count() async {
  setState(() {
    result = '';
    _loading = true;
  });
    
  try {
    int total = 0;
    total = await returnOneAsync();      
    total += await returnTwoAsync();     
    total += await returnThreeAsync();   
    setState(() {
      result = total.toString();
      _loading = false;
    });
  } catch (e) {
    setState(() {
      result = 'An error occurred';
      _loading = false;
    });
  }
}
```
The `count()` method demonstrates the use of async/await for sequential operations:
1. Initially clears the result and shows a loading indicator
2. Uses `await` to wait for the result of each async operation sequentially
3. Sums the results from all three methods (1 + 2 + 3 = 6)
4. Total time taken is approximately 9 seconds because:
   - Waiting for `returnOneAsync()` (3 seconds)
   - Waiting for `returnTwoAsync()` (3 more seconds)
   - Waiting for `returnThreeAsync()` (3 more seconds)
5. Final result (6) is displayed in the UI using `setState()`
6. If an error occurs, it will display "An error occurred"

This code illustrates important concepts in asynchronous programming in Flutter:
- Using Future for time-consuming operations
- Managing loading states during async processes
- Using await to wait for async operation results
- Error handling with try-catch
- Updating UI after async operations complete

![alt text](img/Question4.gif)

## Practicum 3
### Step 2: Adding Completer Implementation 
**Question 5**

This step introduces the use of `Completer` in asynchronous programming:

```dart
late Completer completer;

Future getNumber() {
  completer = Completer<int>();
  calculate();
  return completer.future;
}

Future calculate() async {
  await Future.delayed(const Duration(seconds: 5));
  completer.complete(42);
}
```

**Code Explanation:**

1. **Late Completer Variable:**
  - `late Completer completer;` declares a Completer that will be initialized later
  - Completer is a tool for creating Futures and controlling when they complete

2. **getNumber() Method:**
  - Creates a new `Completer<int>` instance
  - Calls `calculate()` to start the async operation
  - Returns `completer.future` immediately, allowing asynchronous handling
  - The Future will complete when `completer.complete()` is called

3. **calculate() Method:**
  - Simulates a 5-second processing time using `Future.delayed`
  - After the delay, calls `completer.complete(42)` to resolve the Future
  - The value 42 will be delivered to any code awaiting the Future

Result :
![alt text](img/Question5.gif)

## Practicum 4: Calling Futures in parallel
### Question 6

Difference between Step 2 (Completer-based getNumber) and Steps 5–6 (calculate with try/catch and then/catchError handling)

Answer: Step 2 shows a minimal Completer pattern that simply completes a Future after a delay. Steps 5–6 add explicit error-handling inside `calculate()` (using try/catch and `completer.completeError`) and add a `.catchError(...)` handler to the `getNumber().then(...)` call so the UI can react to errors. The result is a safer, more robust flow that propagates failures instead of leaving the Future unresolved.

Detailed comparison
- Step 2 (minimal Completer flow)

```dart
late Completer completer;

Future getNumber() {
  completer = Completer<int>();
  calculate();            // starts work that will eventually call completer.complete(...)
  return completer.future; // caller awaits or attaches then()
}

Future calculate() async {
  await Future.delayed(const Duration(seconds: 5));
  completer.complete(42);
}
```

Behavior and risks:
1. `getNumber()` returns a Future immediately; `calculate()` completes it later with `42`.
2. If `calculate()` throws an exception or never calls `completer.complete(...)`, the returned Future will either complete with an error (if exception propagates to the caller) or hang forever (if the exception is swallowed and `complete` is never called).
3. There is no explicit error propagation or timeout—this is the minimal pattern for demonstrating a Completer.

- Steps 5–6 (explicit error propagation and consumer-side catch)

calculate() was changed to:

```dart
Future calculate() async {
  try {
    await Future.delayed(const Duration(seconds: 5));
    completer.complete(42);
  } catch (_) {
    completer.completeError({}); // signal failure to anyone waiting on completer.future
  }
}
```

and the caller uses:

```dart
getNumber()
  .then((value) {
    setState(() { result = value.toString(); });
  })
  .catchError((e) {
    setState(() { result = 'An error occurred'; });
  });
```

What this changes:
1. Error propagation: `calculate()` explicitly calls `completer.completeError(...)` inside the catch block so that the Future returned by `getNumber()` completes with an error instead of never completing. This makes failures observable to callers.
2. Consumer handling: the caller attaches `.catchError(...)` to handle errors and update the UI. If the completer completes with an error, the `.then(...)` success callback will be skipped and `.catchError(...)` will run.
3. Robustness: the new pattern prevents silent hangs and gives a clear place to react to failures.

Subtle differences and best practices
- Completer semantics: always complete a Completer exactly once — either `complete(value)` or `completeError(error)`. Completing it twice or never completing it are both bugs.
- Use typed Completer: `late Completer<int> completer;` rather than an untyped Completer for better type-safety.
- UI state: in your code `count()` updates `_loading` before work and sets it back afterwards. The `getNumber()` / `calculate()` flow in the README example doesn't toggle `_loading`. For consistent UX you should set `_loading = true` before starting and set `_loading = false` in both the success and error handlers.
- Await vs then/catchError: using `async`/`await` with try/catch (linear style) is generally easier to read and reason about. Using `.then(...).catchError(...)` is equivalent but uses callbacks and can be trickier with nested logic. Either approach is fine if error handling is correct.
![alt text](img/Question6.gif)

## Practicum 4 — Parallel Futures (Instructions)

This practicum shows how to run multiple `Future` operations in parallel to save time. Follow these steps in your editor (VS Code, Android Studio, or your preferred editor). It's assumed you completed Practicum 3.
**Question 7**
- Capture a short GIF showing the result `6` appearing after about 3 seconds and add it to the repository at `img/Question7.gif`.Commit the GIF with message: `W11: Soal 7`.
![alt text](img/Question7.gif)

**Question 8** 
- Step 1 used `FutureGroup` (from `package:async`) which allows adding futures dynamically and closing the group later; useful when you don't have all futures upfront.
- Step 4 used the built-in `Future.wait`, which accepts a list of futures at once and is simpler when the futures are known ahead of time. Both run futures in parallel and return a list of results when all complete.
![alt text](img/Question8.gif)

Notes :
- `FutureGroup` is useful when you collect futures dynamically; `Future.wait` is simpler when the list is known up-front.
- Running futures in parallel reduces total elapsed time to roughly the longest single task.

## Practicum 5 Handling Error Responses in Async Code

**Question 9:**
![alt text](img/Question9.gif)
Result :
- **`.catchError()`** is used to handle errors when a Future fails. It only runs if an exception is thrown. You can check the error and decide what to do (like showing an error message to the user).
- **`.whenComplete()`** always runs, whether the Future succeeds or fails. It's useful for cleanup tasks like stopping a loading spinner, closing a connection, or logging "operation complete".

**Question10**
![alt text](img/Question10.gif)
Result :

- If you call `handleError()` from the `ElevatedButton` and run the app, the method will await `returnError()` which throws after 2 seconds. The `catch` block sets the UI `result` to the error message (for example: `Exception: Something terrible happened!`). The `finally` block always runs and prints `Complete` to the debug console. So you will see the error text in the app and `Complete` in the console.

- Difference between Step 1 and Step 4 (short):
  - Step 1 used `FutureGroup` (from `package:async`) which lets you add futures dynamically and close the group later — useful when you don't have all futures up-front.
  - Step 4 used Dart's built-in `Future.wait`, which takes a list of futures and is simpler when the futures are known ahead of time. Both run futures in parallel and return a list of results when all complete.

## Practicum 6: Using Future with StatefulWidget

**Question11**
![alt text](img/Question11.jpeg)

**Question12**
![alt text](img/Question12.gif)
Do you get GPS coordinates when running in a browser? Why is that? :

No, GPS coordinates cannot be obtained when running on a web browser.Because the Geolocator plugin only works on native platforms (Android, iOS, macOS, Windows, Linux). Web browsers don't have direct access to the device's GPS hardware for security and privacy reasons. Browser geolocation requires explicit user permission through the browser's API, which is different from the native mobile geolocation API.

**Question13 (singkat):** Ya — secara visual hasil akhir (spinner lalu koordinat) bisa sama, tetapi implementasi dengan `FutureBuilder` membuat kode lebih bersih, lebih reaktif, dan otomatis menangani state (loading/sukses/error) tanpa banyak `setState()` manual.

**Question13** 
![alt text](img/Question13.jpeg)
Yes — visually the final result (spinner then coordinates) may look the same, but implementing it with `FutureBuilder` makes the code cleaner, more reactive, and it automatically handles loading/success/error states without many manual `setState()` calls.

**Question 14** 
![alt text](img/Question14.jpeg)
Yes now the app displays an explicit error message when the Future fails.Because we use snapshot.hasError in FutureBuilder to display a special UI in error conditions. Previously, the code only displayed snapshot.data.toString() when it was complete (or empty in other cases), so errors were not handled explicitly. Handling errors in the builder makes the UI more informative and prevents the app from displaying null values or confusion in case of failure.
