# Datasets

| Dataset | URL | collection_id | dataset_id |
| --- | --- | --- | --- |
| Sikkema 2023 HLCA core | https://datasets.cellxgene.cziscience.com/2aa90e63-9a6d-444d-8343-8fc2a9921797.h5ad | 03f821b4-87be-4ff4-b65a-b5fc00061da7 | 2a498ace-872a-4935-984b-1afa70fd9886 |
| Yoshida 2022 PBMC | https://datasets.cellxgene.cziscience.com/926a6acd-6555-4d55-9ba5-6927c9884e96.h5ad | 6f6d381a-7701-4781-935c-db10d30de293 | 066943a2-fdac-4b29-b348-40cede398e4e |

Use the `get_cxg_url` function to get the URL of a dataset by providing the `collection_id` and `dataset_id`.

```python
from utils.cellxgene import get_cxg_url

# get Yoshida data
url = get_cxg_url(
    collection_id="03f821b4-87be-4ff4-b65a-b5fc00061da7",
    dataset_id="2a498ace-872a-4935-984b-1afa70fd9886"
)
```

```bash
curl {url} > Yoshida2022.h5ad
```

```python
import scanpy as sc 
adata = sc.read("Yoshida2022.h5ad")
```