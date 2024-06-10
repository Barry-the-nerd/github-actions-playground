To modify the provided GitHub Action YAML to append a log to a Google Sheet after successfully pushing an image to Docker, follow these steps:

1. **Add the Google Sheets API call in a new step**: Use Google Apps Script to create a web app that can accept POST requests to update the Google Sheet.
2. **Authorize GitHub to write to Google Sheets**: Set up a personal access token in the GitHub secret to authorize the requests.

### Steps:

1. **Create a Google Apps Script Project**:
   - Go to [Google Apps Script](https://script.google.com/).
   - Create a new project.
   - Replace the default code with the following script:

```javascript
function doPost(e) {
  var params = JSON.parse(e.postData.contents);
  var sheetId = 'YOUR_SHEET_ID'; // Replace with your Google Sheet ID
  var sheetName = 'YOUR_SHEET_NAME'; // Replace with your Sheet Name
  
  var ss = SpreadsheetApp.openById(sheetId);
  var sheet = ss.getSheetByName(sheetName);
  
  var newRow = [new Date(), params.image_name, params.tag, params.digest];
  sheet.appendRow(newRow);
  
  return ContentService.createTextOutput(JSON.stringify({"status": "success"})).setMimeType(ContentService.MimeType.JSON);
}
```

2. **Deploy the Google Apps Script as a web app**:
   - Click on `Deploy` > `New deployment`.
   - Select `Web app`.
   - Set `Who has access` to `Anyone`.
   - Deploy and note the URL provided.

3. **Update the GitHub Action YAML**:
   - Add the `curl` command to POST the data to the Google Apps Script URL.

Here is the modified YAML file:

```yaml
name: Build and Push to Dev

on:
  workflow_dispatch:

jobs:
  build:
    runs-on: ubuntu-latest

    env:
      DEV_IMAGE_NAME: docker/imagename

    steps:
    - name: Checkout code
      uses: actions/checkout@v4

....

    - name: Log to Google Sheets
      run: |
        curl -X POST -H "Content-Type: application/json" -d '{"image_name": "${{ env.DEV_IMAGE_NAME }}", "tag": "${{ env.TAG }}", "digest": "${{ env.DIGEST }}"}' ${{ secrets.GOOGLE_SHEETS_WEB_APP_URL }}
```

### Replace placeholders:
- Replace `YOUR_SHEET_ID` with the actual ID of your Google Sheet.
- Replace `YOUR_SHEET_NAME` with the actual name of your sheet.
- Replace `YOUR_GOOGLE_APPS_SCRIPT_WEB_APP_URL` with the URL of your deployed Google Apps Script.

To keep the Google Apps Script web app URL as a secret, you can store it in your GitHub repository secrets. Here are the steps:

### Steps to Add the Secret:
1. Go to your GitHub repository.
2. Click on `Settings`.
3. Select `Secrets and variables` > `Actions`.
4. Click on `New repository secret`.
5. Enter `GOOGLE_SHEETS_WEB_APP_URL` as the name of the secret.
6. Paste your Google Apps Script web app URL as the value.
7. Save the secret.

This setup ensures that your Google Apps Script web app URL is stored securely and used in the GitHub Actions workflow to log details to the Google Sheet.