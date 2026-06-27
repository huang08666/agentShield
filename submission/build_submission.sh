#!/usr/bin/env bash
# Assemble submission folders and create four zip archives.
# Usage: bash submission/build_submission.sh

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SUB="${ROOT}/submission"
OUT="${SUB}/output"

rm -rf "${SUB}/01_documents" "${SUB}/02_executable" "${SUB}/03_sourcecode" "${SUB}/04_other"
mkdir -p "${SUB}/01_documents" "${SUB}/02_executable" "${SUB}/03_sourcecode" "${SUB}/04_other" "${OUT}"

echo "==> 01_documents"
cp "${ROOT}/作品报告_AgentShield.docx" "${SUB}/01_documents/AgentShield_Work_Report.docx"

echo "==> 02_executable"
cp "${ROOT}/deploy/deploy.sh" "${SUB}/02_executable/"
cp "${ROOT}/deploy/verify.sh" "${SUB}/02_executable/"
cp "${ROOT}/scripts/start.sh" "${SUB}/02_executable/"
cp "${ROOT}/scripts/start.ps1" "${SUB}/02_executable/"
cp "${SUB}/run_local_demo.sh" "${SUB}/02_executable/"
cp "${SUB}/run_local_demo.ps1" "${SUB}/02_executable/"
chmod +x "${SUB}/02_executable/"*.sh 2>/dev/null || true

echo "==> 03_sourcecode"
rsync -a --delete \
  --exclude '.git' \
  --exclude '.venv' \
  --exclude 'venv' \
  --exclude 'node_modules' \
  --exclude 'frontend/dist' \
  --exclude 'frontend/.vite' \
  --exclude 'backend/.env' \
  --exclude 'backend/agentshield.db' \
  --exclude 'backend/mock_sent_emails.json' \
  --exclude '**/__pycache__' \
  --exclude '**/.pytest_cache' \
  --exclude 'deploy/DEPLOY-114.215.209.144.md' \
  --exclude 'submission' \
  --exclude '作品报告_AgentShield.docx' \
  "${ROOT}/" "${SUB}/03_sourcecode/"

echo "==> 04_other"
cp "${SUB}/Demo_URL_and_Accounts.txt" "${SUB}/04_other/"
cp "${SUB}/Project_Links.txt" "${SUB}/04_other/"
cp "${SUB}/SUBMISSION_CHECKLIST.txt" "${SUB}/04_other/"

echo "==> Creating zip archives"
(cd "${SUB}/01_documents" && zip -rq "${OUT}/agentshield_documents.zip" .)
(cd "${SUB}/02_executable" && zip -rq "${OUT}/agentshield_executable.zip" .)
(cd "${SUB}/03_sourcecode" && zip -rq "${OUT}/agentshield_sourcecode.zip" .)
(cd "${SUB}/04_other" && zip -rq "${OUT}/agentshield_other.zip" .)

echo ""
echo "Done. Upload these four files:"
ls -lh "${OUT}"/*.zip
