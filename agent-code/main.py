import time

from azure.storage.queue import (
    QueueClient,
    QueueServiceClient,
    BinaryBase64EncodePolicy,
    BinaryBase64DecodePolicy
)
from azure.identity import DefaultAzureCredential, AzureCliCredential, ChainedTokenCredential, ManagedIdentityCredential

cli_cred = DefaultAzureCredential()
mi_cred = ManagedIdentityCredential()
chain_cred = ChainedTokenCredential(cli_cred, mi_cred)

cli_cred = DefaultAzureCredential()
queue_client_mi = QueueClient("https://alertstore.queue.core.windows.net",
    queue_name="alertqueue", message_encode_policy=BinaryBase64EncodePolicy(),
    message_decode_policy=BinaryBase64DecodePolicy(), credential=cli_cred)

while True:
    message = queue_client_mi.receive_message()
    if message is None:
        print("No Message")
        time.sleep(1)
        continue
    print(f"Peeked message: {message.content}")
    queue_client_mi.delete_message(message, pop_receipt=message.pop_receipt)
