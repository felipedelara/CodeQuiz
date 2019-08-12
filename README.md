# CodeQuiz

Quiz iOS app.

<img src="https://github.com/felipedelara/CodeQuiz/blob/development/Screenshot/1.png" width="250">

## Difficulties

### Invalid JSON
- I realised the model init from JSON wouldn't work since the JSON file from the API is invalid - there is a comma missing between key-values. So I created a mock of what the actual result should look like and used on the completion of the service request.
