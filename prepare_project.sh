#!/bin/bash

# --- CONFIGURATION ---
# List of projects
PROJECT_IDS=(
    #"ai-live-labs25gen-2801"
    "ai-live-labs25gen-2802"
    "ai-live-labs25gen-2803"
    # "ai-live-labs25gen-2804"
    # "ai-live-labs25gen-2805"
    # "ai-live-labs25gen-2806"
    # "ai-live-labs25gen-2807"
    # "ai-live-labs25gen-2808"
    # "ai-live-labs25gen-2809"
    # "ai-live-labs25gen-2810"
    # "ai-live-labs25gen-2811"
    # "ai-live-labs25gen-2812"
    # "ai-live-labs25gen-2813"
    # "ai-live-labs25gen-2814"
    # "ai-live-labs25gen-2815"
    # "ai-live-labs25gen-2816"
    # "ai-live-labs25gen-2817"
    # "ai-live-labs25gen-2818"
    # "ai-live-labs25gen-2819"
    # "ai-live-labs25gen-2820"
    # "ai-live-labs25gen-2821"
    # "ai-live-labs25gen-2822"
    # "ai-live-labs25gen-2823"
    # "ai-live-labs25gen-2824"
    # "ai-live-labs25gen-2825"
    # "ai-live-labs25gen-2826"
    # "ai-live-labs25gen-2827"
    # "ai-live-labs25gen-2828"
    # "ai-live-labs25gen-2829"
    # "ai-live-labs25gen-2830"
    # "ai-live-labs25gen-2831"
    # "ai-live-labs25gen-2832"
    # "ai-live-labs25gen-2833"
    # "ai-live-labs25gen-2834"
    # "ai-live-labs25gen-2835"
    # "ai-live-labs25gen-2836"
    # "ai-live-labs25gen-2837"
    # "ai-live-labs25gen-2838"
    # "ai-live-labs25gen-2839"
    # "ai-live-labs25gen-2840"
    # "ai-live-labs25gen-2841"
    # "ai-live-labs25gen-2842"
    # "ai-live-labs25gen-2843"
    # "ai-live-labs25gen-2844"
    # "ai-live-labs25gen-2845"
    # "ai-live-labs25gen-2846"
    # "ai-live-labs25gen-2847"
    # "ai-live-labs25gen-2848"
    # "ai-live-labs25gen-2849"
    # "ai-live-labs25gen-2850"
)

# Set your desired configuration
REGION="us-central1"
TEMPLATE_DISPLAY_NAME="standard-runtime-template"
NETWORK="default"
#MACHINE_TYPE="e2-standard-4"

# --- EXECUTION LOOP ---
for PROJECT in "${PROJECT_IDS[@]}"; do

    echo "------------------------------------------------"
    echo "Processing Project: $PROJECT"

    # Enable the Vertex AI API (Required if not already enabled)
    echo "Enabling APIs"
    gcloud services enable \
        aiplatform.googleapis.com \
        bigquery.googleapis.com \
        bigqueryconnection.googleapis.com \
        compute.googleapis.com \
        --project="$PROJECT"

    sleep 20

    # Create the Notebook Runtime
    echo "Creating Runtime Template..."
    gcloud colab runtime-templates create --display-name="standard-runtime-template" \
        --project="$PROJECT" \
        --region="$REGION" \
        --machine-type="e2-standard-4" \
        --network="$NETWORK"

    if [ $? -eq 0 ]; then
        echo "SUCCESS: Template created for $PROJECT"
    else
        echo "ERROR: Failed to create template for $PROJECT"
    fi

    TEMPLATE_ID=`gcloud colab runtime-templates list --region=us-central1 --project="$PROJECT" | awk '/^ID:/ {print $2}'`

    gcloud colab runtimes create --display-name="standard-runtime" \
        --runtime-template="$TEMPLATE_ID" \
        --project="$PROJECT" \
        --region="$REGION" \
        --labels="aiplatform.googleapis.com/notebook_runtime_out_of_org_warning=ack"
    
    if [ $? -eq 0 ]; then
        echo "SUCCESS: Runtime created for $PROJECT"
    else
        echo "ERROR: Failed to create the runtime for $PROJECT"
    fi


    
done