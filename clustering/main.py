from sklearn.cluster import DBSCAN
import numpy as np
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore

# Use the application default credentials
cred = credentials.ApplicationDefault()
firebase_admin.initialize_app(cred, {
  'projectId': "covid-cluster",
})

store = firestore.client()

def cluster(data, context):
    store = firestore.client()
    doc_ref = store.collection(u'Locations')
    points = []
    
    docs = doc_ref.get()
    for doc in docs:
        points.append(np.array(list(doc.to_dict().values())))
        
    points = np.array(points)

    db = DBSCAN(eps=3, min_samples=15).fit(points)
        
    core_samples_mask = np.zeros_like(db.labels_, dtype=bool)
    core_samples_mask[db.core_sample_indices_] = True
    labels = db.labels_

    # Number of clusters in labels, ignoring noise if present.
    n_clusters_ = len(set(labels)) - (1 if -1 in labels else 0)

    for i in range(n_clusters_):
        points_of_cluster = points[labels==i,:]
        c = np.mean(points_of_cluster, axis=0) 
        store.collection(u'Parties').add({"Longtitude": c[0], "Latitude": c[1]})