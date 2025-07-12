#!/bin/sh
# Copyright (C) 2025 sfwtw <sfwtw@qq.com>
_Vendor="gosuncn"
_Author="test"
_Maintainer="sfwtw <test@qq.com>"
source /usr/share/qmodem/generic.sh
debug_subject="gosuncn_ctrl"

vendor_get_disabled_features()
{
    json_add_string "" "IMEI"
    json_add_string "" "NeighborCell"
}

#获取拨号模式
get_mode()
{
    at_command='AT+ZSWITCH=?'
    local mode_num=$(at ${at_port} ${at_command} | grep -o "#USBCFG:" | awk -F': ' '{print $2}')
    case "$mode_num" in
        "8") mode="mbim" ;;
        "r") mode="rndis" ;;
        "e") mode="ecm" ;;
        "x") mode="rmnet" ;;
        *) mode="${mode_num}" ;;
    esac
    available_modes=$(uci -q get qmodem.$config_section.modes)
    json_add_object "mode"
    for available_mode in $available_modes; do
        if [ "$mode" = "$available_mode" ]; then
            json_add_string "$available_mode" "1"
        else
            json_add_string "$available_mode" "0"
        fi
    done
    json_close_object
}

#设置拨号模式
set_mode()
{
    local mode=$1
    case $mode in
        "8") mode="mbim" ;;
        "r") mode="rndis" ;;
        "e") mode="ecm" ;;
        "x") mode="rmnet" ;;
        *) echo "Invalid mode" && return 1;;
    esac
    at_command='AT+ZSWITCH='${mode}
    res=$(at "${at_port}" "${at_command}")
    json_select "result"
    json_add_string "set_mode" "$res"
    json_close_object
}

#获取网络偏好
get_network_prefer()
{
}

#设置网络偏好
set_network_prefer()
{
}

#获取电压
get_voltage()
{
}

#获取温度
get_temperature()
{
}

#基本信息
base_info()
{
    m_debug  "Gosuncn base info"

    #Name（名称）
    at_command="AT+CGMM?"
    name=$(at $at_port $at_command | sed -n '2p' | sed 's/\r//g')
    #Manufacturer（制造商）
    at_command="AT+CGMI?"
    manufacturer=$(at $at_port $at_command | awk 'NR==2 && NF>0 {print; exit}')
    #Revision（固件版本）
    at_command="AT+CGMR?"
    revision=$(at $at_port $at_command | awk 'NR==2 && NF>0 {print; exit}')

    class="Base Information"
    add_plain_info_entry "manufacturer" "$manufacturer" "Manufacturer"
    add_plain_info_entry "revision" "$revision" "Revision"
    add_plain_info_entry "at_port" "$at_port" "AT Port"
    get_temperature
    get_voltage
    get_connect_status
}

sim_info()
{
}

network_info()
{
}

lte_hex_to_bands() {
}

lte_bands_to_hex() {
}

nr_hex_to_bands() {
}

nr_bands_to_hex() {
}

get_lockband()
{
}

set_lockband()
{
}

calc_average() {
    local values="$1"
    local sum=0
    local count=0
    
    for val in $values; do
        if [ -n "$val" ] && [ "$val" != "NA" ]; then
            sum=$(echo "$sum + $val" | bc -l)
            count=$((count + 1))
        fi
    done
    
    if [ $count -gt 0 ]; then
        printf "%.1f" $(echo "$sum / $count" | bc -l)
    else
        echo "NA"
    fi
}

convert_band_number() {
    local band_num=$1
    case "$band_num" in
        120) echo "B1" ;;
        121) echo "B2" ;;
        122) echo "B3" ;;
        123) echo "B4" ;;
        124) echo "B5" ;;
        125) echo "B6" ;;
        126) echo "B7" ;;
        127) echo "B8" ;;
        128) echo "B9" ;;
        129) echo "B10" ;;
        130) echo "B11" ;;
        131) echo "B12" ;;
        132) echo "B13" ;;
        133) echo "B14" ;;
        134) echo "B17" ;;
        135) echo "B33" ;;
        136) echo "B34" ;;
        137) echo "B35" ;;
        138) echo "B36" ;;
        139) echo "B37" ;;
        140) echo "B38" ;;
        141) echo "B39" ;;
        142) echo "B40" ;;
        143) echo "B18" ;;
        144) echo "B19" ;;
        145) echo "B20" ;;
        146) echo "B21" ;;
        147) echo "B24" ;;
        148) echo "B25" ;;
        149) echo "B41" ;;
        150) echo "B42" ;;
        151) echo "B43" ;;
        152) echo "B23" ;;
        153) echo "B26" ;;
        154) echo "B32" ;;
        155) echo "B125" ;;
        156) echo "B126" ;;
        157) echo "B127" ;;
        158) echo "B28" ;;
        159) echo "B29" ;;
        160) echo "B30" ;;
        161) echo "B66" ;;
        162) echo "B250" ;;
        163) echo "B46" ;;
        166) echo "B71" ;;
        167) echo "B47" ;;
        168) echo "B48" ;;
        250) echo "N1" ;;
        251) echo "N2" ;;
        252) echo "N3" ;;
        253) echo "N5" ;;
        254) echo "N7" ;;
        255) echo "N8" ;;
        256) echo "N20" ;;
        257) echo "N28" ;;
        258) echo "N38" ;;
        259) echo "N41" ;;
        260) echo "N50" ;;
        261) echo "N51" ;;
        262) echo "N66" ;;
        263) echo "N70" ;;
        264) echo "N71" ;;
        265) echo "N74" ;;
        266) echo "N75" ;;
        267) echo "N76" ;;
        268) echo "N77" ;;
        269) echo "N78" ;;
        270) echo "N79" ;;
        271) echo "N80" ;;
        272) echo "N81" ;;
        273) echo "N82" ;;
        274) echo "N83" ;;
        275) echo "N84" ;;
        276) echo "N85" ;;
        277) echo "N257" ;;
        278) echo "N258" ;;
        279) echo "N259" ;;
        280) echo "N260" ;;
        281) echo "N261" ;;
        282) echo "N12" ;;
        283) echo "N25" ;;
        284) echo "N34" ;;
        285) echo "N39" ;;
        286) echo "N40" ;;
        287) echo "N65" ;;
        288) echo "N86" ;;
        289) echo "N48" ;;
        290) echo "N14" ;;
        291) echo "N13" ;;
        292) echo "N18" ;;
        293) echo "N26" ;;
        294) echo "N30" ;;
        295) echo "N29" ;;
        296) echo "N53" ;;
        *) echo "$band_num" ;;
    esac
}

cell_info()
{
}
