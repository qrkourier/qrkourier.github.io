---
title: Cleaning up Google Calendar
tags: python, googlecalendar, googleapis
category: Tech
date: 2023-09-24
---

I stopped using Google Calendar as a primary calendar a few years ago, but I still had a lot of old events in there far into the future. I must have imported the lunar cycle at some point because most of them are named like "New moon" or "Full moon." I wanted to clean them out so I don't see duplicates in my main calendar when I'm subscribed to the Google Calendar for the sake of events that can only be shared there, but there's no way to do bulk operations with the app or website, so I modified the Google API Python quickstart for Calendar to do it for me.

The quickstart starts out by listing the next ten events, and authorizes the readonly scope for calendar events. I changed it to authorize the read/write scope, and to find a larger number events, filter for certain titles, and delete them.

### The Steps I took

1. Completed the [Python Quickstart](https://developers.google.com/calendar/quickstart/python) for the Google Calendar API, and saved the Python program so I could modify it.
1. In the Python program, changed the scope to `https://www.googleapis.com/auth/calendar.events` so I could delete events.
1. Downloaded the JSON credentials file and named it `credentials.json` in the same directory as the Python program.
1. Ran the Python program, which opened a browser window to authorize the app to access my calendar.

### A Simple Python Program to Delete Events by Title

```python
# Copyright 2018 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# [START calendar_quickstart]
from __future__ import print_function

import datetime
import os.path

from google.auth.transport.requests import Request
from google.oauth2.credentials import Credentials
from google_auth_oauthlib.flow import InstalledAppFlow
from googleapiclient.discovery import build
from googleapiclient.errors import HttpError

# If modifying these scopes, delete the file token.json.
SCOPES = ['https://www.googleapis.com/auth/calendar.events']


def main():
    """Shows basic usage of the Google Calendar API.
    Prints the start and name of the next 10 events on the user's calendar.
    """
    creds = None
    # The file token.json stores the user's access and refresh tokens, and is
    # created automatically when the authorization flow completes for the first
    # time.
    if os.path.exists('token.json'):
        creds = Credentials.from_authorized_user_file('token.json', SCOPES)
    # If there are no (valid) credentials available, let the user log in.
    if not creds or not creds.valid:
        if creds and creds.expired and creds.refresh_token:
            creds.refresh(Request())
        else:
            flow = InstalledAppFlow.from_client_secrets_file(
                'credentials.json', SCOPES)
            creds = flow.run_local_server(port=0)
        # Save the credentials for the next run
        with open('token.json', 'w') as token:
            token.write(creds.to_json())

    try:
        service = build('calendar', 'v3', credentials=creds)

        # Call the Calendar API
        now = datetime.datetime.utcnow().isoformat() + 'Z'  # 'Z' indicates UTC time
        # now = '2035-12-29T00:00:00Z'  # 'Z' indicates UTC time
        print(f'Getting events named like "moon" from {now}')
        events_result = service.events().list(calendarId='primary', timeMin=now,
                                              maxResults=999, singleEvents=True,
                                              orderBy='startTime', showDeleted=False).execute()
        events = events_result.get('items', [])

        if not events:
            print('No upcoming events found.')
            return

        # Prints the start and name of the next 10 events
        for event in events:
            title = event['summary']
            if title.find('New moon') != -1 or title.find('Full moon') != -1 or title.find('Blue moon') != -1:
                print(f"Deleting {event['id']} ({title}) with status {event['status']} on {event['start'].get('dateTime', event['start'].get('date'))}")
                delete_result = service.events().delete(calendarId='primary', eventId=event['id']).execute()
            else:
                print(f"Ignoring {event['id']} ({title})")
                continue

    except HttpError as error:
        print('An error occurred: %s' % error)


if __name__ == '__main__':
    main()
# [END calendar_quickstart]
```