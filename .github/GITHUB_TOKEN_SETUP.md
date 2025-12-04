# GitHub Token Setup for Repository Stats

## Problem

The GitHub API has rate limits:

- **Without authentication**: 60 requests/hour
- **With authentication**: 5,000 requests/hour

Since we fetch 6 repository stats and rebuild on every push, we quickly hit the unauthenticated limit, causing repository data to fail loading intermittently.

## Solution

Add a GitHub Personal Access Token to authenticate API requests.

## Setup Steps

### 1. Create a GitHub Personal Access Token

1. Go to <https://github.com/settings/tokens>
2. Click "Generate new token" → "Generate new token (classic)"
3. Give it a descriptive name: `Jekyll Repository Stats`
4. Set expiration (recommend: 1 year)
5. **Required scope**: Select only `public_repo` (read access to public repositories)
6. Click "Generate token"
7. **Copy the token immediately** (you won't be able to see it again)

### 2. Add Token to Repository Secrets

1. Go to your repository: <https://github.com/ma-sadeghi/ma-sadeghi.github.io>
2. Navigate to: **Settings** → **Secrets and variables** → **Actions**
3. Click "New repository secret"
4. Name: `PAT`
5. Value: Paste your token
6. Click "Add secret"

### 3. Verify Setup

The workflow is already configured to use the token. After adding the secret:

1. Push any change to trigger a deployment
2. Check the workflow run at: <https://github.com/ma-sadeghi/ma-sadeghi.github.io/actions>
3. Repository stats should load successfully every time

## Files Modified

- `.github/workflows/deploy.yml` - Added `PAT` secret as `GITHUB_API_TOKEN` environment variable
- `_plugins/jekyll-get-json-auth.rb` - Override plugin to use authenticated requests

## How It Works

The custom plugin in `_plugins/jekyll-get-json-auth.rb`:

1. Detects GitHub API requests
2. Uses the token from `GITHUB_API_TOKEN` environment variable
3. Adds authentication headers to API requests
4. Falls back to unauthenticated requests for non-GitHub URLs
5. Provides better error messages when requests fail

## Troubleshooting

If repository stats still don't load:

1. **Check token is added**: Go to Settings → Secrets → Actions, verify `PAT` exists
2. **Check workflow logs**: Look for "GitHub API Error" messages in build logs
3. **Verify token permissions**: Token needs `public_repo` scope
4. **Check token expiration**: Regenerate if expired

## Local Development

For local development, you can optionally set the token:

```bash
export GITHUB_API_TOKEN="your_token_here"
bundle exec jekyll serve
```

Without the token locally, you'll hit rate limits during development (60 requests/hour).
