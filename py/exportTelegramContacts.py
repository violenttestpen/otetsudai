'''
BEGIN:VCARD
VERSION:2.1
N:<LAST_NAME>;<FIRST_NAME>
FN:<FULL_NAME>
TEL;CELL:<PHONE_NO>
END:VCARD
'''

from pathlib import Path

from telegram.client import Telegram

tg = Telegram(
    api_id='<API_ID>',
    api_hash='<API_HASH>',
    phone='<PHONE_NO>',  # you can pass 'bot_token' instead
    database_encryption_key='changekey123',
)
tg.login()


def getContacts(tg):
    contacts = tg._send_data({'@type': 'getContacts'})
    contacts.wait()
    contacts = contacts.update
    return contacts.get('user_ids', None)


def getUsers(tg, contacts):
    return (_getUser(tg, contact) for contact in contacts)


def _getUser(tg, user_id):
    user = tg._send_data({'@type': 'getUser', 'user_id': user_id})
    user.wait()
    return user.update


def saveAsVCard(users, filename='contacts.vcf'):
    vcards = [_convertTelegramContactToVCard(user) for user in users]
    Path(filename).write_text('\n'.join(vcards) + '\n')
    return len(vcards)


def _convertTelegramContactToVCard(user):
    first_name = user['first_name']
    last_name = user['last_name']
    phone_no = user['phone_number']
    phone_no = phone_no[2:] if phone_no.startswith('65') else phone_no

    result = ["BEGIN:VCARD",
              "VERSION:2.1",
              f"N:{last_name};{first_name}",
              f"FN:{first_name} {last_name}",
              f"TEL;CELL:{phone_no}",
              "END:VCARD"]
    return '\n'.join(result)


contacts = getContacts(tg)
users = getUsers(tg, contacts)
print('Total number of contacts saved:', saveAsVCard(users))
