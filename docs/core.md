# FAIR-data management with the NOMAD infrastructure: Core functionalities

•Joseph F. Rudzinski — Physics Department and CSMB Adlershof, Humboldt-Universität zu Berlin, Germany

*In this first part of the tutorial series, an overview of the NOMAD infrastructure will be provided. Attendees will learn how NOMAD processes raw data and stores it within a generalized data structure, and the corresponding GUI features that allow users to comfortably browse data. An example scenario will also be set up for use throughout the remainder of the tutorial series: A researcher with a variety of data obtained within a project workflow would like to upload this data to NOMAD in order to link it to their manuscript while exposing the details of their (meta)data and retaining the scientifically relevant connections between the individual project tasks.*

## Example Project

You are a researcher investigating the atomic structure and electronic properties of water. Your project workflow uses two distinct methodologies: 1. classical molecular dynamics for generating preliminary structures and 2. geometry optimizations using DFT to fine-tune the structures and recover the electronic properties.


*Challenge:* you are writing a manuscript for publication and have been asked to collect all your data, approprately document all the methodological steps in your procedure, ensuring reproducibility to the greatest extent possible, and to make your data available to the public upon publication.

*Your Approach:* use the NOMAD central repository!

## NOMAD Basics - Processing of supported simulation data

NOMAD ingests the raw input and output files from standard simulation software by first identifying a representative file and then employing a parser code to extract relevant (meta)data from the associated files to that simulation. The (meta)data are stored within a structured schema─the NOMAD Metainfo─to provide context for each quantity, enabling interoperability and comparison between simulation software.

<div class="click-zoom">
    <label>
        <input type="checkbox">
        <img src="../assets/parsing_illustration.png" alt="" width="80%" title="Click to zoom in">
    </label>
</div>

## Drag and drop GUI uploads

You have already performed a standard equilibration workflow for your molecular dynamics simulations, and have organized them in the following directory structure within a zip file:

```
workflow-example-water-atomistic.zip
├── workflow.archive.yaml
├── Emin # Geometry Optimization
│   ├── mdrun_Emin.log # Gromacs mainfile
│   └── ...other raw simulation files
├── Equil-NPT # NPT equilibration
│   ├── mdrun_Equil-NPT.log # Gromacs mainfile
│   └── ...other raw simulation files
└── Prod-NVT # NVT production
    ├── mdrun_Prod-NVT.log # Gromacs mainfile
    └── ...other raw simulation files
```

The simulations were run with the *Gromacs* simulation package. As we will see, the `.log` files will be automatically detected as Gromacs files by NOMAD, followed by the linking to corresponding auxillary files (i.e., other input/output files from that simulation) and, finally, an extraction and storage of all the relevant metadata within NOMAD's structured data schema.

This [example data](https://nomad-lab.eu/prod/v1/gui/user/uploads/upload/id/WWGPCK-URqGmJWkh_9tElQ) has been pre-uploaded and published on NOMAD:

Download the example files by clicking the :fontawesome-solid-cloud-arrow-down: icon. Then go to the [Test NOMAD Deployment](https://nomad-lab.eu/prod/v1/test/gui/search/entries), where you can upload test data that will be periodically deleted. Upload the zip file with the example data as demonstrated in the video below:

![File upload](assets/upload.gif){.screenshot}

TODO - replace all gif with webm or better res somehow


## Browse the overview pages

Click on the right arrows next to each processed entry to browse the overview page of each:

Workflow Entry:

<div class="click-zoom">
    <label>
        <input type="checkbox">
        <img src="../assets/md-upload-workflow.png" alt="" width="100%" title="Click to zoom in">
    </label>
</div>

Production Simulation:

<div class="click-zoom">
    <label>
        <input type="checkbox">
        <img src="../assets/md-upload-prod.gif" alt="" width="100%" title="Click to zoom in">
    </label>
</div>



TODO - save the upload id for publishing



## NOMAD Processing and Organization

The compilation of all (meta)data obtained from this processing forms an entry─the fundamental unit of storage within the NOMAD database─including simulation input/output, author information, and additional general overarching metadata (e.g., references or comments), as well as an `entry_id` &mdash; a unique identifier.

NOMAD entries can be organized hierarchically into uploads, workflows, and data sets. Since the parsing execution is dependent on automated identification of representative files, users are free to arbitrarily group simulations together upon upload. In this case, multiple entries will be created with the corresponding simulation data. An additional unique identifier, `upload_id`, will be provided for this group of entries. Although the grouping of entries into an upload is not necessarily scientifically meaningful, it is practically useful for submitting batches of files from multiple simulations to NOMAD.

NOMAD offers flexibility in the construction of workflows. NOMAD also allows the creation of custom workflows, which are completely general directed graphs, allowing users to link NOMAD entries with one another in order to provide the provenance of the simulation data. Custom workflows are contained within their own entries and, thus, have their own set of unique identifiers. To create a custom workflow, the user is required to upload a workflow yaml file describing the inputs and outputs of each entry within the workflow, with respect to sections of the NOMAD Metainfo schema.

At the highest level, NOMAD groups entries with the use of data sets. A NOMAD data set allows the user to group a large number of entries, without any specification of links between individual entries. A DOI is also generated when a data set is published, providing a convenient route for referencing all data used for a particular investigation within a publication.

TODO - add some diagrams to explain the organization and remove anything that is not necessary to explain here


## GUI tabs and functions

TODO - add images or videos and very short descriptions for what I will walk people through in the tutorial...don't need to explain everything, just enough for people to discover on their own




