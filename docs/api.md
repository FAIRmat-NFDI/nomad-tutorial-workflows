# Using NOMAD’s API for project management

•Nathan Daelman — Physics Department and CSMB Adlershof, Humboldt-Universität zu Berlin, Germany

*In this part of the tutorial series, you will learn how to interface with NOMAD programmatically using a Python module built to simplify the API (application programming interface). Functionalities for uploading data, editing metadata of uploads, creating datasets with multiple uploads, and publishing data will be covered. Attendees will use these functionalities to manage a portion of the data from the example project workflow, in particular, the subset of data that is automatically recognized and processed by one of NOMAD’s existing parsers. (For attendees without any Python experience, an alternative route to upload via the GUI will also be demonstrated!)*

## Programmatic Uploads

In the second part of your research project, you performed a series of DFT calculations for structural comparison with your molecular dynamics simulations.

*Challenge:* You would like to upload these to NOMAD, but this large set of calculations were performed and are currently stored on your groups HPC cluster.

*Your Approach:* use the NOMAD workflow utility plugin!

TODO - add something indicating that this should be done in a notebook or a single python session

## Set up / files and data

On the HPC cluster we have collected our data within the following directory structure:

```
root
├── DFT-1
│   └── 0iCl0nWwCftF0tgQOaklcQLFB68E.zip
│       ├── aims.out # FHIAims mainfile
│       └── ...other raw simulation files
├── DFT-2
│   └── 24Q4MoaAUtsWN7Hepw3UH3TU93pX.zip
│       ├── aims.out # FHIAims mainfile
│       └── ...other raw simulation files
└── DFT-3
│   └── 6V_q8X39he-dakYHifH_3Z53GTdZ.zip
        ├── aims.out # FHIAims mainfile
        └── ...other raw simulation files
```

!!! NOTE
    This data was actually obtained from querying NOMAD for DFT calculations of water, with a certain number of atoms within the simulations. The zip files are named according to the corresponding `entry_id`'s of this data. Instead of supplying the test data directly here, later in this part of the tutorial, we will instead use the API functionalities to reconstruct the above structure by downloading the data directly from NOMAD.

## Install the nomad-utility-workflows plugin

Create a virtual environment with python>=3.9

```sh
python3.11 -m venv .pyenv
. .pyenv/bin/activate
```

Upgrade pip and install uv (recommended):

```sh
pip install --upgrade pip
pip install uv
```

Install the latest pypi version of the plugin using pip:

```bash
pip install nomad-utility-workflows>=0.0.9
```

### Linking to your NOMAD account
Create an account on https://nomad-lab.eu/.
Store your credentials in a `.env` file in your working directory (or in some directory that is added to your `PYTHONPATH`), with the following content
```bash
NOMAD_USERNAME="MyLogin"
NOMAD_PASSWORD="MyPassWord"
```
and insert your username and password. The functions within the utility module will automatically retrieve an authentication token for priveledged operations, e.g., uploading data to your account.


?? Do I need to install nomad or this is only for development?

Install the `nomad-lab` package:
```sh
uv pip install '.[dev]' --index-url https://gitlab.mpcdf.mpg.de/api/v4/projects/2187/packages/pypi/simple
```

## NOMAD URLs / Deployments

The central NOMAD services offer several different deployments with varying purposes and versioning:

- prod: the official NOMAD deployment.
    - Updated most infrequently (as advertised in [#software-updates](https://discordapp.com/channels/1201445470485106719/1275764272122826752) on the NOMAD Discord Server&mdash;If you are not yet a member of the NOMAD server use [Invitation to Discord](https://discord.gg/Gyzx3ukUw8))
- staging: the beta version of NOMAD.
    - Updated more frequently than prod in order to integrate and test new features.
- test: a test NOMAD deployment.
    - The data is occassionally wiped, such that test publishing can be made.

Note that the prod and staging deployments share a common database, and that publishing on either will result in publically available data.

All API functions in `nomad-utility-workflows` allow the user to specify the URL with the optional keyword argument `url`. If you want to use the central NOMAD URLs, you can simply set `url` equal to "prod", "staging", or "test". By default, the test deployment will be used as a safety mechanism to avoid accidentally publishing during testing. Thus, for all examples in this tutorial we will be using the test deployment.

See [nomad-utility-workflow DOCS > NOMAD URLs](https://fairmat-nfdi.github.io/nomad-utility-workflows/how_to/use_api_functions.html#nomad-urls) for more information.

## Uploading The Example Data

The `upload_files_to_nomad()` function can be used to upload data. Try a test upload with some dummy folder to the test deployment (this will also ensure that your authentication info is set up properly):

```python
from nomad_utility_workflows.utils.uploads import upload_files_to_nomad
mkdir Test/
zip -r test.zip Test/
test_upload_fnm = './test.zip'
upload_id = upload_files_to_nomad(filename=test_upload_fnm, url='test')
print(upload_id)
```

??? success "example output"

    ```
    'RdA_3ZsOTMqbtAhYLivVsw'
    ```



### Checking the upload status

The returned `upload_id` can then be used to directly access the upload, e.g., to check the upload status, using `get_upload_by_id()`:


```python
from pprint import pprint
from nomad_utility_workflows.utils.uploads import get_upload_by_id
nomad_upload = get_upload_by_id(upload_id, url='test')
pprint(nomad_upload)
```

??? success "example output"
    ```
    NomadUpload(upload_id='RdA_3ZsOTMqbtAhYLivVsw',
                upload_create_time=datetime.datetime(2024, 10, 15, 20, 2, 10, 378000),
                main_author=NomadUser(name='Joseph Rudzinski'),
                process_running=False,
                current_process='process_upload',
                process_status='SUCCESS',
                last_status_message='Process process_upload completed successfully',
                errors=[],
                warnings=[],
                coauthors=[],
                coauthor_groups=[],
                reviewers=[],
                reviewer_groups=[],
                writers=[NomadUser(name='Joseph Rudzinski')],
                writer_groups=[],
                viewers=[NomadUser(name='Joseph Rudzinski')],
                viewer_groups=[],
                published=False,
                published_to=[],
                with_embargo=False,
                embargo_length=0.0,
                license='CC BY 4.0',
                entries=1,
                n_entries=None,
                upload_files_server_path='/nomad/test/fs/staging/R/RdA_3ZsOTMqbtAhYLivVsw',
                publish_time=None,
                references=None,
                datasets=None,
                external_db=None,
                upload_name=None,
                comment=None,
                url='https://nomad-lab.eu/prod/v1/test/api/v1',
                complete_time=datetime.datetime(2024, 10, 15, 20, 2, 11, 320000))
    ```

One common usage of this function is to ensure that an upload has been processed successfully before making a subsequent action on it, e.g., editing the metadata or publishing. We will apply this functionality in the example below.

### Deleting your upload

Before moving on to the example data, let's delete this dummy upload:

```python
from nomad_utility_workflows.utils.uploads import delete_upload
delete_upload(upload_id, url='test')
```

Wait a few seconds to allow for processing and then check to make sure that the upload was deleted:

```python
try:
    get_upload_by_id(upload_id, url='test')
except Exception:
    print(f'Upload with upload_id={upload_id} was deleted successfully.')
```

??? success "example output"

    'Upload with upload_id=zpq-JTzWQJ63jtSOlbueKA was deleted successfully.'


### Reconstructing the example data

Now that you understand some API basics, let's download the example data from NOMAD and reconstruct the directory structure introduced at the beginning.

```python
import os
from nomad_utility_workflows.utils.entries import download_entry_by_id
entries = ['0iCl0nWwCftF0tgQOaklcQLFB68E', '24Q4MoaAUtsWN7Hepw3UH3TU93pX', '6V_q8X39he-dakYHifH_3Z53GTdZ']
responses = []
for i_entry, entry in enumerate(entries):
    folder_nm = f'DFT-{i_entry}'
    os.system(f'mkdir {folder_nm}')
    responses.append(download_entry_by_id(entry, url='prod', zip_file_name=f'{folder_nm}/{entry}.zip'))
```

!!! note

    Here we have specified `url='prod'` since this data is publically available on the NOMAD production deployment. Make sure to use `url='test'` (or don't specify a url) for other function calls in this tutorial.

If the API call was successful you should find a zip file with each `DFT-X` folder. You can unzip these to ensure that all the raw files are present, i.e., `aims.out`, `aims.in`, etc. You can also investigate the `response` for each API call, which contains the archive (i.e., the full (meta)data stored according to NOMAD's structured schema) for each entry.

### Iterative Uploading with Checks

Although uploads can group multiple entries together, they are limited by the maximum upload size and act more as a practical tool for optimizing the transfer of data to the NOMAD repository. For scientifically relevant connections between entries, NOMAD uses *Datasets* and *Workflows*, which will both be covered later in the tutorial.

For demonstration purposes, we will upload each of the DFT calculations individually, while implementing some checks to ensure successful processing:

```python
import time
from nomad_utility_workflows.utils.uploads import upload_files_to_nomad, get_upload_by_id
entries = ['0iCl0nWwCftF0tgQOaklcQLFB68E', '24Q4MoaAUtsWN7Hepw3UH3TU93pX', '6V_q8X39he-dakYHifH_3Z53GTdZ']
upload_ids = []
responses = []

# define the timing parameters
max_wait_time = 1 * 60  # 1 minute in seconds
interval = 10  # 10 seconds

for i_entry, entry in enumerate(entries):
    fnm = f'./DFT-{i_entry}/{entry}.zip'
    # make the upload
    upload_id = upload_files_to_nomad(filename=fnm, url='test')
    upload_ids.append(upload_id)

    # wait until the upload is processed successfully before continuing
    elapsed_time = 0
    while elapsed_time < max_wait_time:
        nomad_upload = get_upload_by_id(upload_id, url='test')

        # Check if the upload is complete
        if nomad_upload.process_status == 'SUCCESS':
            responses.append(nomad_upload)
            break

        # Wait the specified interval before the next call
        time.sleep(interval)
        elapsed_time += interval
    else:
        raise TimeoutError(f'Maximum wait time of {max_wait_time/60.} minutes exceeded. Upload with id {upload_id} is not complete.')
```

!!! note

    It is not necessary to wait between individual uploads, however, it is advisable to check that a given upload/entry process is complete before trying to execute another.

## Creating Datasets

Let's now create a dataset to group all of our uploaded data together:

```python
from nomad_utility_workflows.utils.datasets import create_dataset
dataset_id = create_dataset('Example Dataset - DPG Tutorial 2025 - <your_name> ', url='test')
print(dataset_id)
```

!!! note

    Make sure to add your name or some unique identifier. Dataset names must be unique.

??? success "example output"

    ```
    'NCKd75f9R9S8rnkd-GBZlg'
    ```

Save the returned `dataset_id` for later use. If you lose it, you can always go to [Test Deployment > PUBLISH > Datasets](https://nomad-lab.eu/prod/v1/test/gui/user/datasets) to view all of your created datasets.


### Editing the upload metadata

Now that your uploads are processed successfully, you can add coauthors, references, and other comments, as well as link to a dataset and provide a name for the upload. Note that the coauthor is specified by an email address that should correspond to the email linked to the person's NOMAD account. See more about searching for users [nomad-utility-workflows DOCS > NOMAD User Metadata](https://fairmat-nfdi.github.io/nomad-utility-workflows/how_to/use_api_functions.html#nomad-user-metadata).

The metadata should be stored as a dictionary as follows:

```python
metadata = {
    "metadata": {
    "upload_name": '<new_upload_name>',
    "references": ["https://doi.org/xx.xxxx/xxxxxx"],
    "datasets": '<dataset_id>',
    "embargo_length": 0,
    "coauthors": ["coauthor@affiliation.de"],
    "comment": 'This is a test upload...'
    },
}
```

Let's simply add a name to each upload and then link them to the dataset that we created:

```python
import time
from nomad_utility_workflows.utils.uploads import edit_upload_metadata
# upload_ids - should be previously defined
# dataset_id - should be previously defined
responses = []

# define the timing parameters
max_wait_time = 30  # 30 seconds
interval = 5  # 5 seconds

for i_upload, upload in enumerate(upload_ids):
    metadata_new = {'upload_name': f'Test Upload - DFT-{i_upload}', 'datasets': dataset_id}
    edit_upload_metadata(upload, url='test', upload_metadata=metadata_new)

    # wait until the upload is processed successfully before continuing
    elapsed_time = 0
    while elapsed_time < max_wait_time:
        nomad_upload = get_upload_by_id(upload, url='test')

        # Check if the edit upload is complete
        if nomad_upload.process_status == 'SUCCESS':
            responses.append(nomad_upload)
            break

        # Wait the specified interval before the next call
        time.sleep(interval)
        elapsed_time += interval
    else:
        raise TimeoutError(f'Maximum wait time of {max_wait_time/60.} minutes exceeded. Edit Upload with id {upload} is not complete.')
```

Let's also add the drag and drop upload with the MD data to our dataset. First, go to [Test Deployment > PUBLISH > Uploads](https://nomad-lab.eu/prod/v1/test/gui/user/uploads) and find the `upload_id` for the MD data.

```python
upload_id = '<md data upload id>'
from nomad_utility_workflows.utils.uploads import edit_upload_metadata
metadata_new = {'upload_name': f'Test Upload - MD-equilibration', 'datasets': dataset_id}
edit_upload_metadata(uploa_id, url='test', upload_metadata=metadata_new)
```

Before moving on, let's check that this additional process is complete:

```python
nomad_upload = get_upload_by_id(upload_id, url='test')

pprint(nomad_upload.process_status == 'SUCCESS')
pprint(nomad_upload.process_running is False)
```

??? success "output"

    ```
    True
    True
    ```

## Publishing Uploads

Before publishing uploads, it is advisable to browse the individual entries to make sure there are no obvious problems, e.g., in the visualizations in the `Overview` tab or in the `LOG` tab (there is a clear red `!` to indicate if there were error in processing). Note that it is possible that the processing reports as successful while still having some errors. If you have to many uploads to inspect manually, choosing a representative subset is advisable. If you find any problems, you can receive assistance by posting on [#software-updates](https://discordapp.com/channels/1201445470485106719/1275764272122826752) on the NOMAD Discord Server&mdash;If you are not yet a member of the NOMAD server use [Invitation to Discord](https://discord.gg/Gyzx3ukUw8).

TODO -- move this discord link to the overview and then just link them to the relevant spots.

We can publish all 4 uploads that we made so far with `publish_upload()`, making it publicly available on the Test NOMAD deployment (again these will be eventually deleted).

!!! note

    Once the upload is published you will no longer be able to make changes to the raw files that you uploaded. However, the upload metadata (accessed and edited in the above example) can be changed after publishing.

TODO - redefine the upload ids so it's more clear

```python
from nomad_utility_workflows.utils.uploads import publish_upload
all_upload_ids = [dft_upload_ids, md_upload_id]
responses = []

# define the timing parameters
max_wait_time = 30  # 30 seconds
interval = 5  # 5 seconds

for upload in all_upload_ids:
    published_upload = publish_upload(upload, url='test')

    # wait until the upload is processed successfully before continuing
    elapsed_time = 0
    while elapsed_time < max_wait_time:
        nomad_upload = get_upload_by_id(upload, url='test')

        # Check if the edit upload is complete
        if nomad_upload.process_status == 'SUCCESS':
            responses.append(nomad_upload)
            break

        # Wait the specified interval before the next call
        time.sleep(interval)
        elapsed_time += interval
    else:
        raise TimeoutError(f'Maximum wait time of {max_wait_time/60.} minutes exceeded. Publish Upload with id {upload} is not complete.')
```

## More Resources

More detailed documentation can be found [nomad-utility-workflows DOCS > Perform API Calls](https://fairmat-nfdi.github.io/nomad-utility-workflows/how_to/use_api_functions.html).
