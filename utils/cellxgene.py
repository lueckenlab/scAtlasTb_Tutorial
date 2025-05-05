def get_cxg_url(collection_id, dataset_id):
    """
    Adapted code from https://github.com/chanzuckerberg/single-cell-curation/blob/main/notebooks/curation_api/python_raw/get_dataset.ipynb
    """
    import requests
    print(f'Get URL for CxG collection ID "{collection_id}" and dataset ID "{dataset_id}"')

    url = f'https://api.cellxgene.cziscience.com/curation/v1/collections/{collection_id}/datasets/{dataset_id}/'
    assets = requests.get(url=url).json()['assets']
    asset = [a for a in assets if a["filetype"] == "H5AD"][0]
    url = asset["url"]

    print(f'URL: {url}')
    return url
