begin
    dq = str_get_dq()
    date_cmd   = "date +" + dq + "%a %b %d %H:%M:%S %Z %Y" + dq
    wcStrt = systemfunc(date_cmd)
;---Processing----------------
    res_path = (/"u3km","v4-60km_33N132E_785410","u60km","u60km_100s"/)
    mpas_data = "/storage/aemolcore02/jungu/2020_Kyushu/"

    mesh_res = (/"u3km","rotated_4-60km_33N132E_785410","u60km","u60km"/)

    ;read rain
    ires = 0
    rainnc_fi = addfile(mpas_data+res_path(ires) +  "/sep_vars/ensemble/monthly_avg/rainnc_hr.nc", "r")
    rainnc = (rainnc_fi->rainnc_hr)*24
    rainc_fi = addfile(mpas_data+res_path(ires) + "/sep_vars/ensemble/monthly_avg/rainc_hr.nc", "r")
    rainc = (rainc_fi->rainc_hr)*24
    rain_u3km = rainnc + rainc ;day

    ires = 1
    rainnc_fi = addfile(mpas_data+res_path(ires) +  "/sep_vars/ensemble/monthly_avg/rainnc_hr.nc", "r")
    rainnc2 = (rainnc_fi->rainnc_hr)*24
    rainc_fi = addfile(mpas_data+res_path(ires) + "/sep_vars/ensemble/monthly_avg/rainc_hr.nc", "r")
    rainc2 = (rainc_fi->rainc_hr)*24
    rain_v4km = rainnc2 + rainc2 ;day

    ires = 2
    rainnc1_fi = addfile(mpas_data+res_path(ires) +  "/sep_vars/ensemble/monthly_avg/rainnc_hr.nc", "r")
    rainnc1 = (rainnc1_fi->rainnc_hr)*24
    rainc1_fi = addfile(mpas_data+res_path(ires) + "/sep_vars/ensemble/monthly_avg/rainc_hr.nc", "r")
    rainc1 = (rainc1_fi->rainc_hr)*24
    rain_u60km = rainnc1 + rainc1 ;day

    CMORPH_rain_path = "/storage/aemolcore02/dongze/U3km_data/cmorph_total_rain_20200611-0709.nc"
    CMORPH_rain_fi = addfile(CMORPH_rain_path, "r")
    rain_cmorph = CMORPH_rain_fi->rain
    rain_cmorph = rain_cmorph/30
    lat_cmorph = CMORPH_rain_fi->lat
    lon_cmorph = CMORPH_rain_fi->lon


    ;read mesh
    mesh_path = "/storage/aemolcore02/jungu/mesh/"
    mesh_fi = addfile(mesh_path + mesh_res(0) + "/cell_fill.nc","r")
    lat_u3km = mesh_fi->latCell
    lon_u3km = mesh_fi->lonCell
    mesh_fi = addfile(mesh_path + mesh_res(1) + "/cell_fill.nc","r")
    lat_v4km = mesh_fi->latCell
    lon_v4km = mesh_fi->lonCell
    mesh_fi = addfile(mesh_path + mesh_res(2) + "/cell_fill.nc","r")
    lat_u60km = mesh_fi->latCell
    lon_u60km = mesh_fi->lonCell

    ;select region
    minlat = -21.
    maxlat = 41.
    minlon = 122.
    maxlon = 154.

    rain_cmorph_region = rain_cmorph({minlat:maxlat},{minlon:maxlon})
    lat_cmorph_region = lat_cmorph({minlat:maxlat})
    lon_cmorph_region = lon_cmorph({minlon:maxlon})

    index_region_u3km = ind(lat_u3km.ge.minlat.and.lat_u3km.le.maxlat.and.lon_u3km.ge.minlon.and.lon_u3km.le.maxlon)
    rain_u3km_region = rain_u3km(index_region_u3km)
    lat_u3km_region = lat_u3km(index_region_u3km)
    lon_u3km_region = lon_u3km(index_region_u3km)

    index_region_v4km = ind(lat_v4km.ge.minlat.and.lat_v4km.le.maxlat.and.lon_v4km.ge.minlon.and.lon_v4km.le.maxlon)
    rain_v4km_region = rain_v4km(index_region_v4km)
    lat_v4km_region = lat_v4km(index_region_v4km)
    lon_v4km_region = lon_v4km(index_region_v4km)

    index_region_u60km = ind(lat_u60km.ge.minlat.and.lat_u60km.le.maxlat.and.lon_u60km.ge.minlon.and.lon_u60km.le.maxlon)
    rain_u60km_region = rain_u60km(index_region_u60km)
    lat_u60km_region = lat_u60km(index_region_u60km)
    lon_u60km_region = lon_u60km(index_region_u60km)

    lat_interval = fspan(-20,40,121);0.5
    rain_region_lat = new((/4,121/),double)
    do i = 0, 120
        index_lat := ind(lat_u3km_region.ge.lat_interval(i)-0.25.and.lat_u3km_region.le.lat_interval(i)+0.25)
        rain_region_lat(0,i) = dim_avg_n_Wrap(rain_u3km_region(index_lat), 0)
        index_v4km_lat := ind(lat_v4km_region.ge.lat_interval(i)-0.25.and.lat_v4km_region.le.lat_interval(i)+0.25)
        rain_region_lat(1,i) = dim_avg_n_Wrap(rain_v4km_region(index_v4km_lat), 0)
        index_u60km_lat := ind(lat_u60km_region.ge.lat_interval(i)-0.25.and.lat_u60km_region.le.lat_interval(i)+0.25)
        rain_region_lat(2,i) = dim_avg_n_Wrap(rain_u60km_region(index_u60km_lat), 0)
        rain_cmorph_subset = rain_cmorph_region({lat_interval(i)-0.25:lat_interval(i)+0.25},:)
        rain_region_lat(3,i) = avg(rain_cmorph_subset)
    end do

;-----------------------------
    wallClockElapseTime(wcStrt, "Processing", 0)
    wcStrtGraphics = systemfunc(date_cmd)
;---Graphics------------------
    wks_name = "Figure1e"
    wks_type = "png"
    N_res = 2
    wks_type@wkHeight = 1024*N_res
    wks_type@wkWidth  = 1024*N_res
    wks = gsn_open_wks(wks_type, wks_name)
    ;set uniform resources
    res = True
    res@gsnDraw = False
    res@gsnFrame= False
    res@gsnMaximize  = False
    res@gsnStringFont = 25
    res@gsnStringFontHeightF = 0.02
    res@gsnLeftString = "(e)"
    res@gsnRightString= ""
    res@gsnLeftStringOrthogonalPosF = 0.0
    res@gsnRightStringOrthogonalPosF = 0.0

    ;set xyline resources
    xyres = res
    ;set a) location
    xyres@vpHeightF = 0.6
    xyres@vpWidthF  = 0.88
    xyres@vpXF = 0.1
    xyres@vpYF = 0.8

    xyres@xyMonoLineThickness = False
    xyres@xyLineThicknesses = (/6.0,6,6,10/) *N_res
    xyres@xyMonoDashPattern = False
    xyres@xyDashPatterns = (/0,0,0,0/)
    xyres@xyLineColors = (/"firebrick1","navyblue","orange","black"/)
    xyres@xyMarkLineMode = "Lines"
    ;xyres@xyMarkers      = (/1,7/)
    ;xyres@xyMarkerSizes  = (/0.02,0.005/);default 0.01
    ;xyres@xyMarkerThicknesses = (/2,8./)
   
    ;xyres@xyMarkerColors := (/"navyblue","orange"/)

    xyres@tmXBMajorLengthF = 0.005
    xyres@tmXBMinorLengthF = 0.003
    xyres@tmXBMajorOutwardLengthF = 0.005
    xyres@tmXBMinorOutwardLengthF = 0.003
    xyres@tmYLMajorLengthF = 0.005
    xyres@tmYLMinorLengthF = 0.003
    xyres@tmYLMajorOutwardLengthF = 0.005
    xyres@tmYLMinorOutwardLengthF = 0.005
    xyres@tmBorderThicknessF =6.0
    xyres@tmXBMajorThicknessF=6.0
    xyres@tmXBMinorThicknessF=6.0
    xyres@tmXBLabelAngleF = 0.
    xyres@tmYLMajorThicknessF=6.0
    xyres@tmYLMinorThicknessF=6.0

    xyres@tiYAxisString = "~F25~Rainfall (mm/day)"
    xyres@tiYAxisFontHeightF = 0.019
    xyres@trYMinF = 0.
    xyres@trYMaxF = 14.
    xyres@trXMinF = 24.
    xyres@trXMaxF = 41.
    xyres@tmXTOn = False
    xyres@tmYROn = False
    xyres@tmXBMode = "Explicit"

    XBValues = ispan(-20,40,5)
    nValues  = dimsizes(XBValues)
    XBLabels = new(nValues,string)
    do i = 0, nValues -1 
        if(XBValues(i) .lt. 0)then
            XBLabels(i) = XBValues(i) + "~S~o~N~S"
        else if (XBValues(i) .gt. 0) then
            XBLabels(i) = XBValues(i) + "~S~o~N~N"
        else
            XBLabels(i) = "0~S~o~N"
        end if
        end if
    end do

    xyres@tmXBValues = XBValues
    ;xyres@tmXBMinorValues = ispan(-20,40,1)
    xyres@tmXBLabels = "~F25~"+ XBLabels
    xyres@tmXBMinorValues = lat_interval
    xyres@tmXBLabelFontHeightF = 0.017
    xyres@tmYLMode = "Explicit"
    xyres@tmYLLabels = "~F25~"+(/0,5,10/)
    xyres@tmYLMinorValues = ispan(0,14,1)
    xyres@tmYLValues = (/0,5,10/)
    xyres@tmYLLabelFontHeightF = 0.017


    xyres@pmLegendDisplayMode = "Always"
    xyres@pmLegendHeightF = 0.1
    xyres@pmLegendWidthF = 0.2
    xyres@pmLegendSide   = "Top"
    xyres@pmLegendOrthogonalPosF = -0.25
    xyres@pmLegendParallelPosF   = 0.12
    xyres@lgLabelFontHeightF = 0.017
    xyres@lgPerimOn = False
    xyres@lgItemOrder = (/3,2,1,0/)
    xyres@xyExplicitLegendLabels = "~F25~" + (/"   U3KM ","   V4KM ","   U60KM ","   CMORPH "/)
    xyres@lgBoxMinorExtentF = 0.2

    plot = gsn_csm_xy(wks,lat_interval,rain_region_lat,xyres)
    draw(plot)
    frame(wks)
    
;-----------------------------
    wallClockElapseTime(wcStrtGraphics, "Graphics", 0)
    wallClockElapseTime(wcStrt, "Processing and Graphics", 0)
end
