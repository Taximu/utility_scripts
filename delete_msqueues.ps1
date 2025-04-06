[Reflection.Assembly]::LoadWithPartialName("System.Messaging")
[System.Messaging.MessageQueue]::GetPrivateQueuesByMachine("someserver") | % {".\" + $_.QueueName} | % {[System.Messaging.MessageQueue]::Delete($_); }
