#!/bin/bash
# Manual fallback script for frontend deployment
echo "Building React application..."
cd ../frontend && npm run build
echo "Syncing to S3..."
aws s3 sync build/ s3://$S3_BUCKET --delete
echo "Invalidating CloudFront..."
aws cloudfront create-invalidation --distribution-id $CLOUDFRONT_DISTRIBUTION_ID --paths "/*"
echo "Frontend deployment complete."