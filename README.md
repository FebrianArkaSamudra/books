# Pemrograman Asynchronous

## Practicum 1

- **Question 1 :** 
![alt text](img/Question1.png)

- **Question 2 :**
![alt text](img/Question2.png)

- **Question 3 :**
- - Explain the meaning of step 5 regarding substring and catchError!
The onPressed code in the ElevatedButton is used to fetch data asynchronously when the button is pressed. The getData() function is executed, and if it succeeds, the response body is converted to a string and trimmed using substring(0, 450) to display only the first 450 characters, preventing the UI from being overloaded with long text. Then, setState() is called to update the UI with the fetched result. If an error occurs, for example due to a failed connection or if the string is shorter than 450 characters, catchError catches the exception and assigns the message 'An error occurred' to the result variable, followed by another setState() call to update the UI with the error message. This ensures that partial data is displayed when successful and that the app does not crash when an error occurs.

![alt text](img/Practicum1.gif)

## Practicum 2
