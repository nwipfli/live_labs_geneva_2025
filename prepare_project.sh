#!/bin/bash

# Set your desired configuration

PROJECT_ID=$(gcloud config get-value project)
REGION="us-central1"
TEMPLATE_DISPLAY_NAME="standard-runtime-template"
NETWORK="default"

# Enable the Vertex AI API (Required if not already enabled)
echo "Enabling APIs"
gcloud services enable \
    aiplatform.googleapis.com \
    bigquery.googleapis.com \
    bigqueryconnection.googleapis.com \
    compute.googleapis.com \
    --project="$PROJECT_ID"

if [ $? -eq 0 ]; then
    echo "SUCCESS: APIs enabled for $PROJECT_ID. Waiting 20 sec."
else
    echo "ERROR: Failed to enable the APIs for $PROJECT_ID"
fi

sleep 20

# Create the Notebook Runtime
echo "Creating Runtime Template..."
gcloud colab runtime-templates create --display-name="standard-runtime-template" \
    --project="$PROJECT_ID" \
    --region="$REGION" \
    --machine-type="e2-standard-4" \
    --network="$NETWORK"

if [ $? -eq 0 ]; then
    echo "SUCCESS: Template created for $PROJECT_ID"
else
    echo "ERROR: Failed to create template for $PROJECT_ID"
fi

TEMPLATE_ID=`gcloud colab runtime-templates list --region=us-central1 --project="$PROJECT_ID" | awk '/^ID:/ {print $2}'`

gcloud colab runtimes create --display-name="standard-runtime" \
    --runtime-template="$TEMPLATE_ID" \
    --project="$PROJECT_ID" \
    --region="$REGION"

if [ $? -eq 0 ]; then
    echo "SUCCESS: Runtime created for $PROJECT_ID"
else
    echo "ERROR: Failed to create the runtime for $PROJECT_ID"
fi

# Create the bucket
    
gcloud storage buckets create gs://"notebooks-$PROJECT_ID" \
    --project="$PROJECT_ID" \
    --default-storage-class="STANDARD" \
    --location="$REGION"

if [ $? -eq 0 ]; then
    echo "SUCCESS: Bucket created for $PROJECT_ID"
else
    echo "ERROR: Failed to create the bucket for $PROJECT_ID"
fi

gcloud storage cp ./Notebooks/* gs://"notebooks-$PROJECT_ID"

if [ $? -eq 0 ]; then
    echo "SUCCESS: Notebooks imported for $PROJECT_ID"
else
    echo "ERROR: Failed to import the notebooks for $PROJECT_ID"
fi

echo "Environment ready !"