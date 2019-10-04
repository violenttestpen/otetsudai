'''
BEGIN:VCARD
VERSION:2.1
N:<LAST_NAME>;<FIRST_NAME>
FN:<FULL_NAME>
TEL;CELL:<PHONE_NO>
END:VCARD
'''

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
    result = 0
    with open(filename, 'w') as f:
        for user in users:
            vcard = _convertTelegramContactToVCard(user)
            f.write(vcard)
            f.write('\n')
            result += 1
    return result


def _convertTelegramContactToVCard(user):
    result = ["BEGIN:VCARD",
              "VERSION:2.1",
              f"N:{user['last_name']};{user['first_name']}",
              f"FN:{user['first_name'] + ' ' + user['last_name']}",
              f"TEL;CELL:{user['phone_number'][2:] \
                          if user['phone_number'].startswith('65') \
                          else user['phone_number']}",
              "END:VCARD"]
    return '\n'.join(result)


contacts = getContacts(tg)
users = getUsers(tg, contacts)
print('Total number of contacts saved:', saveAsVCard(users))
