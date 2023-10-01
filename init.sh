GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo -e "${GREEN}Install build-essentials/git${NC}"
sudo apt install build-essential git -y

#Install github cli
export ghVersion=$(curl -SsL https://api.github.com/repos/cli/cli/releases/latest | jq -r .tag_name| sed 's/v//g')
wget $(printf 'https://github.com/cli/cli/releases/download/v%s/gh_%s_linux_amd64.deb' "$ghVersion" "$ghVersion")
sudo dpkg -i $(printf 'gh_%s_linux_amd64.deb' "$ghVersion")

{
    git config --global user.email "max.mulawa@gmail.com"
    git config --global user.name "Maksymilian Mulawa"
}

#
echo -e "${GREEN}Go to https://github.com/settings/tokens and create PAT${NC}" 
gh auth login  
gh repo clone max-mulawa/toolkit

