#!/bin/bash
set -e

# =============================================================================
# 🎯 DARTOTSU INSTALLER - Beautiful Terminal Experience with Moving Box Animations
# =============================================================================

# Define application details
OWNER='aayush2622'
REPO='Dartotsu'
APP_NAME='Dartotsu'

# Installation paths
INSTALL_DIR="$HOME/.local/share/$APP_NAME"
LINK="$HOME/.local/bin/$APP_NAME"
DESKTOP_FILE="$HOME/.local/share/applications/$APP_NAME.desktop"
ICON_FILE="$HOME/.local/share/icons/$APP_NAME.png"

# =============================================================================
# 🎨 COLORS & STYLING
# =============================================================================

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
GRAY='\033[0;90m'
BOLD='\033[1m'
DIM='\033[2m'
RESET='\033[0m'

# Dartotsu gradient colors (teal to cyan)
GRAD1='\033[38;5;30m'   # Dark teal
GRAD2='\033[38;5;36m'   # Medium teal
GRAD3='\033[38;5;42m'   # Teal
GRAD4='\033[38;5;48m'   # Light teal
GRAD5='\033[38;5;51m'   # Cyan
GRAD6='\033[38;5;87m'   # Bright cyan

# Neon colors for effects
NEON_BLUE='\033[38;5;33m'
NEON_GREEN='\033[38;5;46m'
NEON_PINK='\033[38;5;201m'
NEON_YELLOW='\033[38;5;226m'
NEON_CYAN='\033[38;5;51m'

# Icons
ICON_FIRE="🔥"
ICON_LIGHTNING="⚡"
ICON_STAR="⭐"
ICON_DIAMOND="💎"
ICON_BOMB="💣"
ICON_SKULL="💀"
ICON_ROBOT="🤖"
ICON_ALIEN="👽"
ICON_GHOST="👻"
ICON_MAGIC="🪄"
ICON_CRYSTAL="🔮"
ICON_SWORD="⚔️"
ICON_SHIELD="🛡️"
ICON_CROWN="👑"
ICON_COMET="☄️"
ICON_GALAXY="🌌"

# Animation chars
BOX_CHARS="▀▄█▌▐░▒▓■▣▤▥▦▧▨▩"
WAVE_CHARS="~∼≈∽∿〜"
PULSE_CHARS="●○◐◑◒◓◔◕"

# =============================================================================
# 🎭 ENHANCED ANIMATION & UI FUNCTIONS
# =============================================================================

# Moving box animation like Excel copy selection
moving_box_animation() {
    local width=${1:-60}
    local height=${2:-8}
    local iterations=${3:-3}
    local delay=${4:-0.1}
    
    for ((iter=0; iter<iterations; iter++)); do
        for ((phase=0; phase<4; phase++)); do
            # Clear area
            for ((row=0; row<height+2; row++)); do
                printf "\033[%dA\033[K" 1 2>/dev/null || true
            done
            
            # Draw animated border
            case $phase in
                0) border_char="─" corner_char="┌┐└┘" ;;
                1) border_char="━" corner_char="┏┓┗┛" ;;
                2) border_char="═" corner_char="╔╗╚╝" ;;
                3) border_char="▬" corner_char="▀▀▄▄" ;;
            esac
            
            # Get corner characters
            tl="${corner_char:0:1}"
            tr="${corner_char:1:1}"
            bl="${corner_char:2:1}"
            br="${corner_char:3:1}"
            
            # Animate with color gradient
            local color=""
            case $phase in
                0) color="$NEON_BLUE" ;;
                1) color="$NEON_GREEN" ;;
                2) color="$NEON_PINK" ;;
                3) color="$NEON_CYAN" ;;
            esac
            
            # Top border
            printf "${color}${BOLD}%s" "$tl"
            for ((i=0; i<width-2; i++)); do
                printf "%s" "$border_char"
            done
            printf "%s${RESET}\n" "$tr"
            
            # Side borders with moving content
            for ((r=1; r<height-1; r++)); do
                printf "${color}${BOLD}│${RESET}"
                
                # Moving pattern inside
                for ((c=0; c<width-2; c++)); do
                    local pos=$(( (c + r + phase + iter*4) % 8 ))
                    case $pos in
                        0|4) printf "${DIM}░${RESET}" ;;
                        1|5) printf "${GRAY}▒${RESET}" ;;
                        2|6) printf "${WHITE}▓${RESET}" ;;
                        3|7) printf "${BOLD}█${RESET}" ;;
                    esac
                done
                
                printf "${color}${BOLD}│${RESET}\n"
            done
            
            # Bottom border
            printf "${color}${BOLD}%s" "$bl"
            for ((i=0; i<width-2; i++)); do
                printf "%s" "$border_char"
            done
            printf "%s${RESET}\n" "$br"
            
            sleep $delay
        done
    done
}

# Pulse animation for text
pulse_text() {
    local text="$1"
    local iterations=${2:-3}
    local delay=${3:-0.3}
    
    for ((i=0; i<iterations; i++)); do
        for char in $PULSE_CHARS; do
            printf "\r${NEON_PINK}${BOLD}%s${RESET} %s" "$char" "$text"
            sleep $delay
        done
    done
    printf "\r✨ %s\n" "$text"
}

# Wave animation for borders
wave_border() {
    local width=${1:-60}
    local iterations=${2:-2}
    local delay=${3:-0.05}
    
    for ((iter=0; iter<iterations; iter++)); do
        for ((offset=0; offset<8; offset++)); do
            printf "\r"
            for ((i=0; i<width; i++)); do
                local wave_pos=$(( (i + offset) % 6 ))
                case $wave_pos in
                    0) printf "${NEON_BLUE}~${RESET}" ;;
                    1) printf "${NEON_CYAN}∼${RESET}" ;;
                    2) printf "${NEON_GREEN}≈${RESET}" ;;
                    3) printf "${NEON_YELLOW}∽${RESET}" ;;
                    4) printf "${NEON_PINK}∿${RESET}" ;;
                    5) printf "${PURPLE}〜${RESET}" ;;
                esac
            done
            sleep $delay
        done
    done
    echo
}

# Matrix-style cascading text
matrix_cascade() {
    local text="$1"
    local width=${2:-60}
    local height=${3:-8}
    
    # Create matrix effect
    for ((row=0; row<height; row++)); do
        for ((col=0; col<width; col++)); do
            if (( RANDOM % 4 == 0 )); then
                printf "${NEON_GREEN}%c${RESET}" $((RANDOM % 26 + 65))
            else
                printf " "
            fi
        done
        echo
        sleep 0.03
    done
    
    # Clear and show actual text
    for ((i=0; i<height; i++)); do
        printf "\033[1A\033[K"
    done
    
    pulse_text "$text" 2 0.2
}

# Enhanced spinner with box movement
enhanced_spinner() {
    local pid=$1
    local message="${2:-Processing}"
    local delay=0.08
    local box_chars="▖▘▝▗▖▘▝▗"
    local colors=("$NEON_BLUE" "$NEON_GREEN" "$NEON_YELLOW" "$NEON_PINK" "$NEON_CYAN")
    local i=0
    
    while [ "$(ps a | awk '{print $1}' | grep $pid 2>/dev/null)" ]; do
        local color=${colors[$((i % ${#colors[@]}))]}
        local char=${box_chars:$((i % ${#box_chars})):1}
        printf "\r ${color}${BOLD}%s${RESET} %s..." "$char" "$message"
        ((i++))
        sleep $delay
    done
    printf "\r ${GREEN}${BOLD}✓${RESET} %s... ${GREEN}Done!${RESET}\n" "$message"
}

# Animated progress bar with moving elements
animated_progress_bar() {
    local current=$1
    local total=$2
    local width=50
    local percentage=$((current * 100 / total))
    local filled=$((current * width / total))
    local empty=$((width - filled))

    # Color gradient based on progress
    local fill_color=""
    local bg_color="${GRAY}"
    if [ $percentage -lt 25 ]; then
        fill_color="${RED}"
    elif [ $percentage -lt 50 ]; then
        fill_color="${YELLOW}"
    elif [ $percentage -lt 75 ]; then
        fill_color="${CYAN}"
    else
        fill_color="${GREEN}"
    fi

    printf "\r${BOLD}${ICON_LIGHTNING} Progress: ${RESET}["
    
    # Animated fill with different patterns
    for ((i=0; i<filled; i++)); do
        local pattern=$(( (i + $(date +%s)) % 4 ))
        case $pattern in
            0) printf "${fill_color}█${RESET}" ;;
            1) printf "${fill_color}▓${RESET}" ;;
            2) printf "${fill_color}▒${RESET}" ;;
            3) printf "${fill_color}░${RESET}" ;;
        esac
    done
    
    # Moving cursor at progress edge
    if [ $filled -lt $width ]; then
        printf "${WHITE}${BOLD}▶${RESET}"
        ((empty--))
    fi
    
    # Empty space with subtle pattern
    for ((i=0; i<empty; i++)); do
        if (( i % 3 == 0 )); then
            printf "${bg_color}░${RESET}"
        else
            printf "${bg_color}·${RESET}"
        fi
    done
    
    printf "] ${BOLD}${fill_color}%d%%${RESET} ${ICON_FIRE}" $percentage
}

# Compare commits with enhanced visuals
compare_commits() {
    local main_repo="aayush2622/Dartotsu"
    local alpha_repo="grayankit/Dartotsu-Downloader"

    echo
    pulse_text "Initiating quantum commit analysis" 2 0.2
    
    # Moving box animation during data fetch
    echo -e "${CYAN}${DIM}> Accessing GitHub API...${RESET}"
    moving_box_animation 40 3 1 0.1 &
    local anim_pid=$!
    
    # Get data
    local main_commit=$(curl -s "https://api.github.com/repos/${main_repo}/commits" | grep '"sha"' | head -1 | cut -d '"' -f 4 | cut -c1-7) 2>/dev/null
    local main_date=$(curl -s "https://api.github.com/repos/${main_repo}/commits" | grep '"date"' | head -1 | cut -d '"' -f 4) 2>/dev/null
    local main_author=$(curl -s "https://api.github.com/repos/${main_repo}/commits" | grep '"name"' | head -1 | cut -d '"' -f 4) 2>/dev/null

    local alpha_release=$(curl -s "https://api.github.com/repos/${alpha_repo}/releases/latest") 2>/dev/null
    local alpha_tag=$(echo "$alpha_release" | grep '"tag_name"' | cut -d '"' -f 4) 2>/dev/null
    local alpha_date=$(echo "$alpha_release" | grep '"published_at"' | cut -d '"' -f 4) 2>/dev/null

    # Stop animation
    kill $anim_pid 2>/dev/null || true
    wait $anim_pid 2>/dev/null || true
    
    # Clear animation area
    for ((i=0; i<5; i++)); do
        printf "\033[1A\033[K"
    done

    echo
    # Animated border
    wave_border 65 2 0.03
    
    echo -e "${BOLD}${PURPLE}╔═══════════════════════════════════════════════════════════════╗${RESET}"
    echo -e "${BOLD}${PURPLE}║${RESET}                    ${ICON_CRYSTAL} COMMIT MATRIX ${ICON_CRYSTAL}                    ${PURPLE}${BOLD}║${RESET}"
    echo -e "${BOLD}${PURPLE}╠═══════════════════════════════════════════════════════════════╣${RESET}"
    echo -e "${BOLD}${PURPLE}║${RESET}                                                         ${PURPLE}${BOLD}║${RESET}"
    echo -e "${BOLD}${PURPLE}║${RESET} ${ICON_GALAXY} ${BOLD}MAIN REPOSITORY${RESET} ${GRAY}(${main_repo})${RESET}          ${PURPLE}${BOLD}║${RESET}"
    echo -e "${BOLD}${PURPLE}║${RESET}   ${ICON_DIAMOND} Commit SHA: ${NEON_YELLOW}${BOLD}${main_commit}${RESET}                           ${PURPLE}${BOLD}║${RESET}"
    echo -e "${BOLD}${PURPLE}║${RESET}   ${ICON_STAR} Author: ${NEON_CYAN}${main_author}${RESET}                              ${PURPLE}${BOLD}║${RESET}"
    echo -e "${BOLD}${PURPLE}║${RESET}   ${ICON_COMET} Timestamp: ${GRAY}$(date -d "$main_date" '+%Y-%m-%d %H:%M:%S UTC' 2>/dev/null || echo "Unknown")${RESET}  ${PURPLE}${BOLD}║${RESET}"
    echo -e "${BOLD}${PURPLE}║${RESET}                                                         ${PURPLE}${BOLD}║${RESET}"
    echo -e "${BOLD}${PURPLE}║${RESET} ${ICON_ALIEN} ${BOLD}ALPHA REPOSITORY${RESET} ${GRAY}(${alpha_repo})${RESET} ${PURPLE}${BOLD}║${RESET}"
    echo -e "${BOLD}${PURPLE}║${RESET}   ${ICON_BOMB} Release Tag: ${NEON_PINK}${BOLD}${alpha_tag}${RESET}                            ${PURPLE}${BOLD}║${RESET}"
    echo -e "${BOLD}${PURPLE}║${RESET}   ${ICON_GHOST} Published: ${GRAY}$(date -d "$alpha_date" '+%Y-%m-%d %H:%M:%S UTC' 2>/dev/null || echo "Unknown")${RESET}    ${PURPLE}${BOLD}║${RESET}"
    echo -e "${BOLD}${PURPLE}║${RESET}                                                         ${PURPLE}${BOLD}║${RESET}"

    # Sync status with epic effects
    if [[ "$alpha_tag" == *"$main_commit"* ]]; then
        echo -e "${BOLD}${PURPLE}║${RESET}   ${ICON_MAGIC} SYNC STATUS: ${NEON_GREEN}${BOLD}${ICON_FIRE} PERFECTLY SYNCHRONIZED ${ICON_FIRE}${RESET}   ${PURPLE}${BOLD}║${RESET}"
        echo -e "${BOLD}${PURPLE}║${RESET}   ${NEON_GREEN}${ICON_LIGHTNING} Repositories are in perfect harmony! ${ICON_LIGHTNING}${RESET}           ${PURPLE}${BOLD}║${RESET}"
    else
        echo -e "${BOLD}${PURPLE}║${RESET}   ${ICON_CRYSTAL} SYNC STATUS: ${NEON_YELLOW}${BOLD}${ICON_SWORD} DIVERGED TIMELINES ${ICON_SWORD}${RESET}     ${PURPLE}${BOLD}║${RESET}"
        echo -e "${BOLD}${PURPLE}║${RESET}   ${NEON_YELLOW}${ICON_SKULL} Alpha may contain different features ${ICON_SKULL}${RESET}            ${PURPLE}${BOLD}║${RESET}"
    fi

    echo -e "${BOLD}${PURPLE}║${RESET}                                                         ${PURPLE}${BOLD}║${RESET}"
    echo -e "${BOLD}${PURPLE}╚═══════════════════════════════════════════════════════════════╝${RESET}"
    
    wave_border 65 2 0.03
    echo

    # Cool countdown with moving boxes
    echo -ne "${BOLD}${CYAN}Preparing alpha download in: ${RESET}"
    for i in 3 2 1; do
        printf "${NEON_PINK}${BOLD}[%d]${RESET}" $i
        sleep 0.8
        printf "\b\b\b   \b\b\b"
    done
    echo -e "${NEON_GREEN}${BOLD}[GO!] ${ICON_LIGHTNING}${RESET}"
    echo
}

# Enhanced typing effect with cursor
type_text_enhanced() {
    local text="$1"
    local delay=${2:-0.03}
    local cursor="${3:-▋}"
    
    for ((i=0; i<=${#text}; i++)); do
        printf "\r%s${NEON_CYAN}%s${RESET}" "${text:0:$i}" "$cursor"
        sleep $delay
    done
    printf "\r%s \n" "$text"
}

# Cool banner with animated elements
show_banner() {
    clear
    echo
    
    # Animated top border
    wave_border 72 2 0.02
    
    # ASCII art with gradient animation
    local banner_lines=(
        "  ██████╗  █████╗ ██████╗ ████████╗ ██████╗ ████████╗███████╗██╗   ██╗"
        "  ██╔══██╗██╔══██╗██╔══██╗╚══██╔══╝██╔═══██╗╚══██╔══╝██╔════╝██║   ██║"
        "  ██║  ██║███████║██████╔╝   ██║   ██║   ██║   ██║   ███████╗██║   ██║"
        "  ██║  ██║██╔══██║██╔══██╗   ██║   ██║   ██║   ██║   ╚════██║██║   ██║"
        "  ██████╔╝██║  ██║██║  ██║   ██║   ╚██████╔╝   ██║   ███████║╚██████╔╝"
        "  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝    ╚═════╝    ╚═╝   ╚══════╝ ╚═════╝ "
    )
    
    local gradients=("$GRAD1" "$GRAD2" "$GRAD3" "$GRAD4" "$GRAD5" "$GRAD6")
    
    for i in "${!banner_lines[@]}"; do
        local color=${gradients[$i]}
        echo -e "${color}${banner_lines[$i]}${RESET}"
        sleep 0.1
    done
    
    echo
    pulse_text "The Ultimate Anime & Manga Experience" 2 0.3
    
    # Moving separator
    wave_border 72 1 0.02
    
    echo -e "${PURPLE}${DIM}                           ${ICON_GALAXY} Powered by Dreams ${ICON_GALAXY}${RESET}"
    echo
}

# Enhanced section headers with moving elements
section_header() {
    local title="$1"
    local icon="$2"
    
    echo
    # Animated box around title
    moving_box_animation 55 3 1 0.05 &
    local anim_pid=$!
    
    sleep 0.3
    kill $anim_pid 2>/dev/null || true
    wait $anim_pid 2>/dev/null || true
    
    # Clear animation
    for ((i=0; i<5; i++)); do
        printf "\033[1A\033[K"
    done
    
    echo -e "${BOLD}${BLUE}╭─────────────────────────────────────────────────────╮${RESET}"
    echo -e "${BOLD}${BLUE}│${RESET} ${icon} ${BOLD}${WHITE}${title}${RESET} ${BLUE}│${RESET}"
    echo -e "${BOLD}${BLUE}╰─────────────────────────────────────────────────────╯${RESET}"
    echo
}

# Enhanced success/error messages with animations
success_msg() {
    local msg="$1"
    echo
    pulse_text "SUCCESS!" 1 0.2
    echo -e "${GREEN}${BOLD}┌─ ✨ SUCCESS! ─────────────────────────────────────────┐${RESET}"
    echo -e "${GREEN}${BOLD}│${RESET} ${ICON_STAR} ${msg} ${GREEN}${BOLD}│${RESET}"
    echo -e "${GREEN}${BOLD}└────────────────────────────────────────────────────┘${RESET}"
    echo
}

error_msg() {
    local msg="$1"
    echo
    echo -e "${RED}${BOLD}┌─ ❌ ERROR! ───────────────────────────────────────────┐${RESET}"
    echo -e "${RED}${BOLD}│${RESET} ${ICON_SKULL} ${msg} ${RED}${BOLD}│${RESET}"
    echo -e "${RED}${BOLD}└────────────────────────────────────────────────────┘${RESET}"
    echo
}

# Enhanced info/warning messages
info_msg() {
    local msg="$1"
    echo -e "${NEON_CYAN}${ICON_LIGHTNING}${RESET} ${msg}"
}

warn_msg() {
    local msg="$1"
    echo -e "${NEON_YELLOW}⚠️${RESET} ${msg}"
}

# Enhanced menu with moving elements
show_menu() {
    # Glitch effect title
    local title_chars=("D" "A" "R" "T" "O" "T" "S" "U" " " "C" "O" "N" "T" "R" "O" "L" " " "P" "A" "N" "E" "L")
    printf "${GRAD1}█${GRAD2}█${GRAD3}█${GRAD4}█${GRAD5}█${GRAD6}█${RESET} ${BOLD}"
    for char in "${title_chars[@]}"; do
        printf "%s" "$char"
        sleep 0.02
    done
    printf "${RESET} ${GRAD6}█${GRAD5}█${GRAD4}█${GRAD3}█${GRAD2}█${GRAD1}█${RESET}\n"
    
    echo
    
    # Animated menu border
    moving_box_animation 57 12 1 0.08 &
    local anim_pid=$!
    sleep 0.5
    kill $anim_pid 2>/dev/null || true
    wait $anim_pid 2>/dev/null || true
    
    # Clear animation
    for ((i=0; i<14; i++)); do
        printf "\033[1A\033[K"
    done
    
    echo -e "${BOLD}${NEON_CYAN}╔═══════════════════════════════════════════════════════╗${RESET}"
    echo -e "${BOLD}${NEON_CYAN}║${RESET}                                                     ${NEON_CYAN}${BOLD}║${RESET}"
    echo -e "${BOLD}${NEON_CYAN}║${RESET}  ${ICON_ROBOT} ${NEON_GREEN}${BOLD}[I]${RESET} ${ICON_DOWNLOAD} Install Dartotsu ${GRAY}(Get Started)${RESET}      ${NEON_CYAN}${BOLD}║${RESET}"
    echo -e "${BOLD}${NEON_CYAN}║${RESET}      ${GREEN}Deploy the ultimate anime experience${RESET}        ${NEON_CYAN}${BOLD}║${RESET}"
    echo -e "${BOLD}${NEON_CYAN}║${RESET}                                                     ${NEON_CYAN}${BOLD}║${RESET}"
    echo -e "${BOLD}${NEON_CYAN}║${RESET}  ${ICON_LIGHTNING} ${NEON_YELLOW}${BOLD}[U]${RESET} ${ICON_STAR} Update Dartotsu ${GRAY}(Stay Current)${RESET}     ${NEON_CYAN}${BOLD}║${RESET}"
    echo -e "${BOLD}${NEON_CYAN}║${RESET}      ${YELLOW}Upgrade to the latest and greatest${RESET}         ${NEON_CYAN}${BOLD}║${RESET}"
    echo -e "${BOLD}${NEON_CYAN}║${RESET}                                                     ${NEON_CYAN}${BOLD}║${RESET}"
    echo -e "${BOLD}${NEON_CYAN}║${RESET}  ${ICON_BOMB} ${NEON_PINK}${BOLD}[R]${RESET} ${ICON_SKULL} Remove Dartotsu ${GRAY}(Nuclear Option)${RESET}   ${NEON_CYAN}${BOLD}║${RESET}"
    echo -e "${BOLD}${NEON_CYAN}║${RESET}      ${RED}Complete annihilation of installation${RESET}       ${NEON_CYAN}${BOLD}║${RESET}"
    echo -e "${BOLD}${NEON_CYAN}║${RESET}                                                     ${NEON_CYAN}${BOLD}║${RESET}"
    echo -e "${BOLD}${NEON_CYAN}║${RESET}  ${ICON_GHOST} ${CYAN}${BOLD}[Q]${RESET} ${ICON_MAGIC} Quit ${GRAY}(Escape the Matrix)${RESET}            ${NEON_CYAN}${BOLD}║${RESET}"
    echo -e "${BOLD}${NEON_CYAN}║${RESET}      ${CYAN}Return to the real world${RESET}                   ${NEON_CYAN}${BOLD}║${RESET}"
    echo -e "${BOLD}${NEON_CYAN}║${RESET}                                                     ${NEON_CYAN}${BOLD}║${RESET}"
    echo -e "${BOLD}${NEON_CYAN}╚═══════════════════════════════════════════════════════╝${RESET}"
    echo
    echo -ne "${BOLD}${WHITE}Enter the matrix${RESET} ${GRAY}(I/U/R/Q)${RESET} ${ICON_MAGIC}: "
}

# Enhanced version menu
version_menu() {
    echo
    # Animated title
    matrix_cascade "VERSION SELECTION" 50 4
    
    # Moving box animation before showing menu
    moving_box_animation 55 8 1 0.06 &
    local anim_pid=$!
    sleep 0.6
    kill $anim_pid 2>/dev/null || true
    wait $anim_pid 2>/dev/null || true
    
    # Clear animation
    for ((i=0; i<10; i++)); do
        printf "\033[1A\033[K"
    done

    echo -e "${BOLD}${GRAD2}╔═══════════════════════════════════════════════════════╗${RESET}"
    echo -e "${BOLD}${GRAD2}║${RESET}                                                     ${GRAD2}${BOLD}║${RESET}"
    echo -e "${BOLD}${GRAD2}║${RESET}  ${ICON_CROWN} ${NEON_GREEN}${BOLD}[S]${RESET} Stable Release ${GRAY}(Battle-Tested)${RESET}         ${GRAD2}${BOLD}║${RESET}"
    echo -e "${BOLD}${GRAD2}║${RESET}      ${ICON_SHIELD} Rock solid, enterprise ready            ${GRAD2}${BOLD}║${RESET}"
    echo -e "${BOLD}${GRAD2}║${RESET}                                                     ${GRAD2}${BOLD}║${RESET}"
    echo -e "${BOLD}${GRAD2}║${RESET}  ${ICON_LIGHTNING} ${NEON_YELLOW}${BOLD}[P]${RESET} Pre-release ${GRAY}(Bleeding Edge)${RESET}          ${GRAD2}${BOLD}║${RESET}"
    echo -e "${BOLD}${GRAD2}║${RESET}      ${ICON_FIRE} Latest features, some bugs possible     ${GRAD2}${BOLD}║${RESET}"
    echo -e "${BOLD}${GRAD2}║${RESET}                                                     ${GRAD2}${BOLD}║${RESET}"
    echo -e "${BOLD}${GRAD2}║${RESET}  ${ICON_BOMB} ${NEON_PINK}${BOLD}[A]${RESET} Alpha Build ${GRAY}(Danger Zone!)${RESET}            ${GRAD2}${BOLD}║${RESET}"
    echo -e "${BOLD}${GRAD2}║${RESET}      ${ICON_SKULL} Experimental, use at your own risk     ${GRAD2}${BOLD}║${RESET}"
    echo -e "${BOLD}${GRAD2}║${RESET}                                                     ${GRAD2}${BOLD}║${RESET}"
    echo -e "${BOLD}${GRAD2}╚═══════════════════════════════════════════════════════╝${RESET}"
    echo
    echo -ne "${BOLD}${WHITE}Choose your destiny${RESET} ${GRAY}(S/P/A)${RESET} ${ICON_MAGIC}: "
}

# =============================================================================
# 🐚 SHELL ALIAS MANAGEMENT
# =============================================================================

detect_shell_rc() {
  local shell_name
  shell_name=$(basename "$SHELL")
  case "$shell_name" in
    bash) echo "$HOME/.bashrc" ;;
    zsh) echo "$HOME/.zshrc" ;;
    fish) echo "$HOME/.config/fish/config.fish" ;;
    *) echo "$HOME/.profile" ;;
  esac
}

add_updater_alias() {
  local shell_rc
  shell_rc=$(detect_shell_rc)
  local alias_line="alias dartotsu-updater='bash <(curl -s https://raw.githubusercontent.com/aayush2622/Dartotsu/main/scripts/install.sh) update'"

  if grep -Fxq "$alias_line" "$shell_rc" 2>/dev/null; then
    echo -ne "${YELLOW}⚠️${RESET} The 'dartotsu-updater' alias already exists in your shell config file ($(basename "$shell_rc")). Would you like to remove it? [y/N]: "
    read -r remove_response
    case "$remove_response" in
      [yY][eE][sS]|[yY])
        sed -i "\|$alias_line|d" "$shell_rc"
        echo -e " ${GREEN}✓ Alias removed from $(basename "$shell_rc")${RESET}"
        ;;
      *)
        echo -e " ${CYAN}ℹ️ Keeping existing alias.${RESET}"
        ;;
    esac
  else
    echo -ne "${CYAN}${ICON_MAGIC}${RESET} Would you like to add the 'dartotsu-updater' alias to your shell config file ($(basename "$shell_rc"))? [y/N]: "
    read -r add_response
    case "$add_response" in
      [yY][eE][sS]|[yY])
        echo "$alias_line" >> "$shell_rc"
        echo -e " ${GREEN}✓ Alias added to $(basename "$shell_rc")${RESET}"
        info_msg "You can now run '${BOLD}dartotsu-updater${RESET}' to update anytime!"
        info_msg "Run '${BOLD}source $shell_rc${RESET}' or restart your terminal to activate the alias"
        ;;
      *)
        echo -e " ${YELLOW}⚠️ Skipped adding alias${RESET}"
        ;;
    esac
  fi
}

# =============================================================================
# 🛠️ ENHANCED DEPENDENCY MANAGEMENT
# =============================================================================

# Check if running in container/CI
is_containerized() {
    [ -f /.dockerenv ] || [ -n "${CI:-}" ] || [ -n "${GITHUB_ACTIONS:-}" ]
}

# Enhanced dependency checking with better error handling
check_dependencies() {
    local missing_deps=()
    local optional_deps=()

    # Check command-line tools
    command -v curl >/dev/null 2>&1 || missing_deps+=("curl")
    command -v unzip >/dev/null 2>&1 || missing_deps+=("unzip")
    command -v wget >/dev/null 2>&1 || missing_deps+=("wget")
    command -v mpv >/dev/null 2>&1 || missing_deps+=("mpv")

    # Check optional tools
    command -v git >/dev/null 2>&1 || optional_deps+=("git")

    # Check libraries using pkg-config
    if command -v pkg-config >/dev/null 2>&1; then
        # Check for WebKit2GTK with fallback to older version
        if ! pkg-config --exists webkit2gtk-4.1 2>/dev/null; then
            if ! pkg-config --exists libwebkit2gtk-4.1-0 2>/dev/null; then
                missing_deps+=("webkit2gtk")
            fi
        fi

        # Additional library checks for GUI applications
        pkg-config --exists gtk+-3.0 2>/dev/null || missing_deps+=("gtk3")
    else
        missing_deps+=("pkg-config" "webkit2gtk" "gtk3")
    fi

    # Report missing dependencies
    if [ ${#missing_deps[@]} -ne 0 ]; then
        warn_msg "Missing required dependencies: ${missing_deps[*]}"

        if [ ${#optional_deps[@]} -ne 0 ]; then
            info_msg "Optional dependencies not found: ${optional_deps[*]}"
        fi

        echo
        if is_containerized; then
            info_msg "Container environment detected - attempting automatic installation..."
            export DEBIAN_FRONTEND=noninteractive
            install_packages "${missing_deps[@]}"
        else
            echo -e "${YELLOW}${BOLD}Would you like to install required dependencies automatically?${RESET} ${GRAY}(y/N)${RESET}: "
            read -rn 1 INSTALL_DEPS
            echo

            if [[ "${INSTALL_DEPS,,}" == "y" ]]; then
                install_packages "${missing_deps[@]}"
            else
                error_exit "Required dependencies must be installed to continue: ${missing_deps[*]}"
            fi
        fi
    elif [ ${#optional_deps[@]} -ne 0 ]; then
        info_msg "Optional dependencies not found: ${optional_deps[*]}"
        echo -e "${GRAY}These are not required but may provide additional functionality.${RESET}"
    else
        info_msg "All dependencies are satisfied!"
    fi
}

# Enhanced package installation with better error recovery
install_packages() {
    local deps=("$@")
    local install_cmd=""
    local update_cmd=""
    local distro=""

    # Detect distribution and package manager
    if command -v apt >/dev/null 2>&1; then
        distro="debian"
        update_cmd="sudo apt update -y"
        install_cmd="sudo apt install -y"

        # Map library names to Ubuntu/Debian package names
        deps=("${deps[@]/webkit2gtk/libwebkit2gtk-4.1-0}")
        deps=("${deps[@]/gtk3/libgtk-3-dev}")
        deps=("${deps[@]/pkg-config/pkg-config}")

    elif command -v dnf >/dev/null 2>&1; then
        distro="fedora"
        install_cmd="sudo dnf install -y"

        # Map library names to Fedora package names
        deps=("${deps[@]/webkit2gtk/webkit2gtk4.1-0}")
        deps=("${deps[@]/gtk3/gtk3-devel}")
        deps=("${deps[@]/pkg-config/pkgconf-devel}")

    elif command -v pacman >/dev/null 2>&1; then
        distro="arch"
        update_cmd="sudo pacman -Sy"
        install_cmd="sudo pacman -S --noconfirm"

        # Map library names to Arch package names
        deps=("${deps[@]/webkit2gtk/webkit2gtk-4.1}")
        deps=("${deps[@]/gtk3/gtk3}")
        deps=("${deps[@]/pkg-config/pkgconf}")

    elif command -v zypper >/dev/null 2>&1; then
        distro="opensuse"
        install_cmd="sudo zypper install -y"

        # Map library names to openSUSE package names
        deps=("${deps[@]/webkit2gtk/webkit2gtk3-devel}")
        deps=("${deps[@]/gtk3/gtk3-devel}")
        deps=("${deps[@]/pkg-config/pkg-config}")

    elif command -v brew >/dev/null 2>&1; then
        distro="macos"
        install_cmd="brew install"

        # Map library names to Homebrew package names
        deps=("${deps[@]/webkit2gtk/}")  # Remove webkit2gtk for macOS
        deps=("${deps[@]/gtk3/gtk+3}")
        deps=("${deps[@]/pkg-config/pkg-config}")

    else
        error_exit "No supported package manager found! Please install manually: ${deps[*]}"
    fi

    # Filter out empty elements
    local filtered_deps=()
    for dep in "${deps[@]}"; do
        [[ -n "$dep" ]] && filtered_deps+=("$dep")
    done
    deps=("${filtered_deps[@]}")

    if [ ${#deps[@]} -eq 0 ]; then
        info_msg "No packages to install for this system."
        return 0
    fi

    info_msg "Detected system: $distro"
    info_msg "Installing packages: ${deps[*]}"

    # Update package lists if needed
    if [ -n "$update_cmd" ]; then
        echo -ne "${CYAN}📦${RESET} Updating package lists..."
        if eval "$update_cmd" >/dev/null 2>&1; then
            echo -e " ${GREEN}✓${RESET}"
        else
            echo -e " ${YELLOW}⚠️ Update failed, continuing...${RESET}"
        fi
    fi

    # Install packages with enhanced animation
    enhanced_spinner $ "Installing dependencies" &
    local spinner_pid=$!
    
    if eval "$install_cmd ${deps[*]}" >/dev/null 2>&1; then
        kill $spinner_pid 2>/dev/null || true
        wait $spinner_pid 2>/dev/null || true
        echo -e "\r ${GREEN}✓ Dependencies installed successfully!${RESET}                "
    else
        kill $spinner_pid 2>/dev/null || true
        wait $spinner_pid 2>/dev/null || true
        echo -e "\r ${RED}❌ Installation failed!${RESET}                                "

        # Try installing packages individually to identify problematic ones
        warn_msg "Attempting to install packages individually..."
        local failed_packages=()

        for pkg in "${deps[@]}"; do
            echo -ne "  Installing $pkg..."
            if eval "$install_cmd $pkg" >/dev/null 2>&1; then
                echo -e " ${GREEN}✓${RESET}"
            else
                echo -e " ${RED}❌${RESET}"
                failed_packages+=("$pkg")
            fi
        done

        if [ ${#failed_packages[@]} -ne 0 ]; then
            error_exit "Failed to install: ${failed_packages[*]}. Please install manually."
        fi
    fi
}

# Verify installation of critical dependencies
verify_installation() {
    local critical_deps=("curl" "unzip" "wget")
    local failed_deps=()

    for dep in "${critical_deps[@]}"; do
        if ! command -v "$dep" >/dev/null 2>&1; then
            failed_deps+=("$dep")
        fi
    done

    if [ ${#failed_deps[@]} -ne 0 ]; then
        error_exit "Critical dependencies still missing after installation: ${failed_deps[*]}"
    fi

    # Verify library installations
    if command -v pkg-config >/dev/null 2>&1; then
        if ! pkg-config --exists webkit2gtk-4.1 2>/dev/null && ! pkg-config --exists webkit2gtk-3.0 2>/dev/null; then
            warn_msg "WebKit2GTK may not be properly installed - some features may not work"
        fi
    fi

    info_msg "Installation verification completed!"
}

# =============================================================================
# 🛠️  CORE FUNCTIONS
# =============================================================================

error_exit() {
    error_msg "$1"
    echo -e "${GRAY}${DIM}Press any key to exit...${RESET}"
    read -rn 1
    exit 1
}

download_with_progress() {
    local url="$1"
    local output="$2"
    local filename=$(basename "$url")

    echo -ne "${CYAN}📥${RESET} Downloading ${BOLD}${filename}${RESET}..."

    # Download in background and show enhanced spinner
    curl -sL "$url" -o "$output" &
    local curl_pid=$!
    enhanced_spinner $curl_pid "Downloading $filename"
    wait $curl_pid
    local exit_code=$?

    if [ $exit_code -eq 0 ]; then
        echo -e " ${GREEN}✓ Download completed!${RESET}"
    else
        echo -e " ${RED}❌ Download failed!${RESET}"
        return 1
    fi
}

install_app() {
    section_header "INSTALLATION PROCESS" "🚀"

    # Check dependencies with enhanced system
    info_msg "Checking system dependencies..."
    check_dependencies
    verify_installation
    echo -e "  ${GREEN}✓ All dependencies verified!${RESET}"
    echo

    # Version selection
    version_menu
    read -rn 1 ANSWER
    echo

    # Replace the case statement with enhanced animations
    case "${ANSWER,,}" in
        p)
            API_URL="https://api.github.com/repos/$OWNER/$REPO/releases"
            pulse_text "Fetching pre-release versions..." 1 0.2
            ;;
        a)
            OWNER="grayankit"
            REPO="Dartotsu-Downloader"
            API_URL="https://api.github.com/repos/$OWNER/$REPO/releases/latest"
            pulse_text "Fetching alpha build..." 1 0.2
            echo
            compare_commits
            ;;
        s|"")
            API_URL="https://api.github.com/repos/$OWNER/$REPO/releases/latest"
            pulse_text "Fetching stable release..." 1 0.2
            ;;
        *)
            warn_msg "Invalid selection, defaulting to stable release..."
            API_URL="https://api.github.com/repos/$OWNER/$REPO/releases/latest"
            ;;
    esac

    # Fetch release info with animation
    enhanced_spinner $ "Fetching release information" &
    local spinner_pid=$!
    ASSET_URL=$(curl -s "$API_URL" | grep browser_download_url | cut -d '"' -f 4 | grep .zip | head -n 1)
    kill $spinner_pid 2>/dev/null || true
    wait $spinner_pid 2>/dev/null || true

    if [ -z "$ASSET_URL" ]; then
        error_exit "No downloadable assets found in the release!"
    fi

    # Download with enhanced progress
    echo
    if ! download_with_progress "$ASSET_URL" "/tmp/$APP_NAME.zip"; then
        error_exit "Download failed!"
    fi

    # Installation with moving box animation
    echo
    info_msg "Installing to ${BOLD}$INSTALL_DIR${RESET}..."

    if [ -d "$INSTALL_DIR" ]; then
        warn_msg "Existing installation detected - removing old version..."
        rm -rf "$INSTALL_DIR"
    fi

    mkdir -p "$INSTALL_DIR"

    # Show moving box during extraction
    moving_box_animation 50 4 2 0.05 &
    local extract_anim_pid=$!
    
    if unzip "/tmp/$APP_NAME.zip" -d "$INSTALL_DIR" > /dev/null 2>&1; then
        kill $extract_anim_pid 2>/dev/null || true
        wait $extract_anim_pid 2>/dev/null || true
        # Clear animation
        for ((i=0; i<6; i++)); do
            printf "\033[1A\033[K"
        done
        echo -e "${GREEN}✓ Files extracted successfully!${RESET}"
    else
        kill $extract_anim_pid 2>/dev/null || true
        wait $extract_anim_pid 2>/dev/null || true
        error_exit "Failed to extract application files!"
    fi

    # Find executable
    APP_EXECUTABLE="$(find "$INSTALL_DIR" -type f -executable -print -quit)"
    if [ -z "$APP_EXECUTABLE" ]; then
        error_exit "No executable found in the extracted files!"
    fi

    chmod +x "$APP_EXECUTABLE"

    # Create symlink
    mkdir -p "$HOME/.local/bin"
    ln -sf "$APP_EXECUTABLE" "$LINK"

    # Install icon with animation
    enhanced_spinner $ "Installing icon" &
    local icon_spinner_pid=$!
    mkdir -p "$(dirname "$ICON_FILE")"
    fallback_icon_url='https://raw.githubusercontent.com/aayush2622/Dartotsu/main/assets/images/logo.png'
    if wget -q "$fallback_icon_url" -O "$ICON_FILE" 2>/dev/null; then
        kill $icon_spinner_pid 2>/dev/null || true
        wait $icon_spinner_pid 2>/dev/null || true
        echo -e "\r ${GREEN}✓ Icon installed successfully!${RESET}                      "
    else
        kill $icon_spinner_pid 2>/dev/null || true
        wait $icon_spinner_pid 2>/dev/null || true
        echo -e "\r ${YELLOW}⚠️ Icon download failed (non-critical)${RESET}              "
    fi

    # Create desktop entry
    echo -ne "${CYAN}🖥️${RESET} Creating desktop entry..."
    mkdir -p "$(dirname "$DESKTOP_FILE")"
    cat > "$DESKTOP_FILE" <<EOL
[Desktop Entry]
Name=$APP_NAME
Comment=The Ultimate Anime & Manga Experience
Exec=$LINK
Icon=$ICON_FILE
Type=Application
Categories=AudioVideo;Player
MimeType=x-scheme-handler/dar;x-scheme-handler/anymex;x-scheme-handler/sugoireads;x-scheme-handler/mangayomi;
EOL
    chmod +x "$DESKTOP_FILE"

    if command -v update-desktop-database >/dev/null 2>&1; then
        update-desktop-database "$HOME/.local/share/applications" 2>/dev/null
    fi
    echo -e " ${GREEN}✓ Done!${RESET}"

    # Create shell alias for easy updates
    add_updater_alias

    # Cleanup
    rm -f "/tmp/$APP_NAME.zip"

    echo
    success_msg "$APP_NAME has been installed successfully!"
    info_msg "You can now launch it from your applications menu or run: ${BOLD}$APP_NAME${RESET}"

    echo
    echo -e "${GRAY}${DIM}Press any key to continue...${RESET}"
    read -rn 1
}

uninstall_app() {
    section_header "UNINSTALLATION PROCESS" "🗑️"

    if [ ! -d "$INSTALL_DIR" ] && [ ! -L "$LINK" ]; then
        warn_msg "$APP_NAME doesn't appear to be installed!"
        echo
        echo -e "${GRAY}${DIM}Press any key to continue...${RESET}"
        read -rn 1
        return
    fi

    echo -e "${YELLOW}${BOLD}Are you sure you want to remove $APP_NAME?${RESET} ${GRAY}(y/N)${RESET}: "
    read -rn 1 CONFIRM
    echo

    if [[ "${CONFIRM,,}" != "y" ]]; then
        info_msg "Uninstallation cancelled."
        echo
        echo -e "${GRAY}${DIM}Press any key to continue...${RESET}"
        read -rn 1
        return
    fi

    echo
    pulse_text "Removing $APP_NAME components..." 1 0.2

    # Remove components with animations
    if [ -L "$LINK" ]; then
        enhanced_spinner $ "Removing executable symlink" &
        local spinner_pid=$!
        rm -f "$LINK"
        kill $spinner_pid 2>/dev/null || true
        wait $spinner_pid 2>/dev/null || true
        echo -e "\r  ${GREEN}✓ Executable symlink removed${RESET}                        "
    fi

    if [ -d "$INSTALL_DIR" ]; then
        enhanced_spinner $ "Removing installation directory" &
        local spinner_pid=$!
        rm -rf "$INSTALL_DIR"
        kill $spinner_pid 2>/dev/null || true
        wait $spinner_pid 2>/dev/null || true
        echo -e "\r  ${GREEN}✓ Installation directory removed${RESET}                    "
    fi

    if [ -f "$DESKTOP_FILE" ]; then
        rm -f "$DESKTOP_FILE"
        echo -e "  ${GREEN}✓ Desktop entry removed${RESET}"
    fi

    if [ -f "$ICON_FILE" ]; then
        rm -f "$ICON_FILE"
        echo -e "  ${GREEN}✓ Icon removed${RESET}"
    fi

    if command -v update-desktop-database >/dev/null 2>&1; then
        update-desktop-database "$HOME/.local/share/applications" 2>/dev/null
    fi

    echo
    success_msg "$APP_NAME has been completely removed!"

    echo
    echo -e "${GRAY}${DIM}Press any key to continue...${RESET}"
    read -rn 1
}

update_app() {
    section_header "UPDATE PROCESS" "🔄"

    if [ ! -d "$INSTALL_DIR" ] && [ ! -L "$LINK" ]; then
        warn_msg "$APP_NAME doesn't appear to be installed!"
        info_msg "Would you like to install it instead? ${GRAY}(y/N)${RESET}: "
        read -rn 1 INSTALL_INSTEAD
        echo

        if [[ "${INSTALL_INSTEAD,,}" == "y" ]]; then
            install_app
        else
            echo -e "${GRAY}${DIM}Press any key to continue...${RESET}"
            read -rn 1
        fi
        return
    fi

    pulse_text "Updating $APP_NAME to the latest version..." 1 0.2
    echo
    install_app

    # Ensure alias is still present after update
    add_updater_alias
}

# =============================================================================
# 🚀 MAIN SCRIPT
# =============================================================================

main_loop() {
    while true; do
        show_banner
        show_menu
        read -rn 1 ACTION
        echo

        case "${ACTION,,}" in
            i|install)
                install_app
                ;;
            u|update)
                update_app
                ;;
            r|remove|uninstall)
                uninstall_app
                ;;
            q|quit|exit)
                echo
                type_text_enhanced "Thanks for using Dartotsu Installer! ✨" 0.05
                echo -e "${GRAY}${DIM}Goodbye!${RESET}"
                exit 0
                ;;
            *)
                echo
                warn_msg "Invalid selection! Please choose I, U, R, or Q."
                echo -e "${GRAY}${DIM}Press any key to continue...${RESET}"
                read -rn 1
                ;;
        esac
    done
}

# Check if running in interactive mode
if [ $# -gt 0 ]; then
    # Non-interactive mode - handle command line arguments
    ACTION="$1"
    case "${ACTION,,}" in
        install)
            show_banner
            install_app
            ;;
        update)
            show_banner
            update_app
            ;;
        uninstall|remove)
            show_banner
            uninstall_app
            ;;
        *)
            show_banner
            echo -e "${RED}Usage: $0 [install|update|uninstall]${RESET}"
            echo -e "${GRAY}Or run without arguments for interactive mode.${RESET}"
            exit 1
            ;;
    esac
elif [ -t 0 ]; then
    # Interactive mode - show menu
    main_loop
else
    # Fallback to interactive mode
    main_loop
fi
