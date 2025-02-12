# Creating custom workflow entries in NOMAD to link multiple uploads

•Bernadette Mohr — Physics Department and CSMB Adlershof, Humboldt-Universität zu Berlin, Germany

*In this last part of the tutorial series, attendees will complete the example project workflow storage by creating a custom workflow entry in NOMAD that connects all the uploaded tasks. The basics of the schema for defining custom workflows will be covered, followed by a demonstration of the straightforward creation of the required workflow file using the same workflow utility Python module as in the first part of the tutorial series. Finally, attendees will navigate NOMAD's interactive workflow graph visualizations to investigate the uploaded data, and learn how to obtain a DOI for their workflow.*

## ...

- This one should come together straightforwardly based on the rest, need to create a custom overarching workflow and then a workflow for step 2 api, maybe add one more step (or maybe if step 3 has some data that is local?) that we will upload at the same time, then run the workflow utilities and the api upload, finished with the publishing of the dataset for the api






















## Publishing Uploads

Once the processing of your upload is successful and you have added/adjusted the appropriate metadata, you can publish your upload with `publish_upload()`, making it publicly available on the corresponding NOMAD deployment.

Note that once the upload is published you will no longer be able to make changes to the raw files that you uploaded. However, the upload metadata (accessed and edited in the above example) can be changed after publishing.


```python
published_upload = publish_upload(nomad_upload.upload_id, url='test')
published_upload
```

??? success "output"

    ```
    {'upload_id': 'RdA_3ZsOTMqbtAhYLivVsw',
     'data': {'process_running': True,
      'current_process': 'publish_upload',
      'process_status': 'PENDING',
      'last_status_message': 'Pending: publish_upload',
      'errors': [],
      'warnings': [],
      'complete_time': '2024-10-15T20:03:51.605000',
      'upload_id': 'RdA_3ZsOTMqbtAhYLivVsw',
      'upload_name': 'Test Upload',
      'upload_create_time': '2024-10-15T20:02:10.378000',
      'main_author': '8f052e1f-1906-41fd-b2eb-690c03407788',
      'coauthors': [],
      'coauthor_groups': [],
      'reviewers': [],
      'reviewer_groups': [],
      'writers': ['8f052e1f-1906-41fd-b2eb-690c03407788'],
      'writer_groups': [],
      'viewers': ['8f052e1f-1906-41fd-b2eb-690c03407788'],
      'viewer_groups': [],
      'published': False,
      'published_to': [],
      'with_embargo': False,
      'embargo_length': 0,
      'license': 'CC BY 4.0',
      'entries': 1,
      'upload_files_server_path': '/nomad/test/fs/staging/R/RdA_3ZsOTMqbtAhYLivVsw'}}
    ```


## How to use api functionalities

Imports for the following examples:


```python
import time
from pprint import pprint

from decouple import config as environ

from nomad_utility_workflows.utils.core import get_authentication_token
from nomad_utility_workflows.utils.datasets import (
    create_dataset,
    delete_dataset,
    get_dataset_by_id,
    retrieve_datasets,
)
from nomad_utility_workflows.utils.entries import (
    download_entry_by_id,
    get_entries_of_my_uploads,
    get_entries_of_upload,
    get_entry_by_id,
    query_entries,
)
from nomad_utility_workflows.utils.uploads import (
    delete_upload,
    edit_upload_metadata,
    get_all_my_uploads,
    get_upload_by_id,
    publish_upload,
    upload_files_to_nomad,
)
from nomad_utility_workflows.utils.users import (
    get_user_by_id,
    search_users_by_name,
    who_am_i,
)
```