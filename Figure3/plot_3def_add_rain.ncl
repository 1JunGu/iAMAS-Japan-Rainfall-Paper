begin
    dq = str_get_dq()
    date_cmd   = "date +" + dq + "%a %b %d %H:%M:%S %Z %Y" + dq
    wcStrt = systemfunc(date_cmd)

;---Processing----------------
    res_list = (/"u3km","v4-60km_33N132E_785410","u60km"/)
    mpas_data = "/storage/aemolcore02/jungu/2020_Kyushu/" + res_list + "/ensemble/mpas_out/monthly_avg/sep_vars/ERA5/"

    rain_data = "/storage/aemolcore02/jungu/2020_Kyushu/" + res_list

    minlat = -21.
    maxlat = 51.
    minlon = 122.
    maxlon = 154.
    ;cmorph
    CMORPH_rain_path = "/storage/aemolcore02/dongze/U3km_data/cmorph_total_rain_20200611-0709.nc"
    CMORPH_rain_fi = addfile(CMORPH_rain_path, "r")
    rain_cmorph = CMORPH_rain_fi->rain
    rain_cmorph = rain_cmorph/30
    lat_cmorph = CMORPH_rain_fi->lat
    lon_cmorph = CMORPH_rain_fi->lon

    ;u3km
    ires = 0
    qv_u3km_fi = addfile(mpas_data(ires) + "qv_ERA5.nc","r")
    qv_u3km = qv_u3km_fi->qv({95000:20000},{minlat:maxlat},{minlon:maxlon})
    qv_u3km&nLevels@units = "Pa"
    qv_u3km = qv_u3km*1000
    qv_u3km := dim_avg_n_Wrap(qv_u3km,2)

    theta_u3km_fi = addfile(mpas_data(ires) + "theta_ERA5.nc","r")
    theta_u3km = theta_u3km_fi->theta({95000:20000},{minlat:maxlat},{minlon:maxlon})
    theta_u3km&nLevels@units = "Pa"
    nlevels = theta_u3km&nLevels
    nlevels := conform(theta_u3km,nlevels,0)
    T_u3km =  theta_u3km*(nlevels/100000.)^0.286
    T_u3km = T_u3km - 273.15

    copy_VarCoords(theta_u3km,T_u3km)
    T_u3km := dim_avg_n_Wrap(T_u3km,2)

    w_u3km_fi = addfile(mpas_data(ires) + "w_ERA5.nc","r")
    w_u3km = w_u3km_fi->w({920000:20000},{minlat:maxlat},{minlon:maxlon})
    w_u3km&nLevels@units = "Pa"
    ;w_u3km = w_u3km*100

    v_u3km_fi = addfile(mpas_data(ires) + "uReconstructMeridional_ERA5.nc","r")
    v_u3km = v_u3km_fi->uReconstructMeridional({920000:20000},{minlat:maxlat},{minlon:maxlon})
    v_u3km&nLevels@units = "Pa"


    w_u3km_reg_avg = dim_avg_n_Wrap(w_u3km, 2)
    v_u3km_reg_avg = dim_avg_n_Wrap(v_u3km, 2)
    ;w_u3km_reg_vc = w_u3km_reg_avg*200

    w_u3km_reg_avg_layer = dim_avg_n_Wrap(w_u3km_reg_avg,1)
    w_u3km_reg_avg_conform = conform(w_u3km_reg_avg,w_u3km_reg_avg_layer,0)
    ;normalize method1
    w_u3km_reg_avg = w_u3km_reg_avg - w_u3km_reg_avg_conform
    wscale_u3km = w_u3km_reg_avg*100                       ; now scale
    w_u3km_reg_vc = w_u3km_reg_avg*200
    copy_VarCoords(v_u3km_reg_avg, wscale_u3km)              ; copy coordinate variables

    rainnc_fi = addfile(rain_data(ires) +  "/sep_vars/ensemble/monthly_avg/rainnc_hr.nc", "r")
    rainnc = (rainnc_fi->rainnc_hr)*24
    rainc_fi = addfile(rain_data(ires) + "/sep_vars/ensemble/monthly_avg/rainc_hr.nc", "r")
    rainc = (rainc_fi->rainc_hr)*24
    rain_u3km = rainnc + rainc ;day
;v4km
    ires = 1
    qv_v4km_fi = addfile(mpas_data(ires) + "qv_ERA5.nc","r")
    qv_v4km = qv_v4km_fi->qv({95000:20000},{minlat:maxlat},{minlon:maxlon})
    qv_v4km&nLevels@units = "Pa"
    qv_v4km = qv_v4km*1000
    qv_v4km := dim_avg_n_Wrap(qv_v4km,2)

    theta_v4km_fi = addfile(mpas_data(ires) + "theta_ERA5.nc","r")
    theta_v4km = theta_v4km_fi->theta({95000:20000},{minlat:maxlat},{minlon:maxlon})
    theta_v4km&nLevels@units = "Pa"
    T_v4km =  theta_v4km*(nlevels/100000.)^0.286
    T_v4km = T_v4km - 273.15

    copy_VarCoords(theta_v4km,T_v4km)
    T_v4km := dim_avg_n_Wrap(T_v4km,2)

    w_v4km_fi = addfile(mpas_data(ires) + "w_ERA5.nc","r")
    w_v4km = w_v4km_fi->w({920000:20000},{minlat:maxlat},{minlon:maxlon})
    w_v4km&nLevels@units = "Pa"
    ;w_v4km = w_v4km*100

    v_v4km_fi = addfile(mpas_data(ires) + "uReconstructMeridional_ERA5.nc","r")
    v_v4km = v_v4km_fi->uReconstructMeridional({920000:20000},{minlat:maxlat},{minlon:maxlon})
    v_v4km&nLevels@units = "Pa"


    w_v4km_reg_avg = dim_avg_n_Wrap(w_v4km, 2)
    v_v4km_reg_avg = dim_avg_n_Wrap(v_v4km, 2)
    ;w_v4km_reg_vc = w_v4km_reg_avg*200

    w_v4km_reg_avg_layer = dim_avg_n_Wrap(w_v4km_reg_avg,1)
    w_v4km_reg_avg_conform = conform(w_v4km_reg_avg,w_v4km_reg_avg_layer,0)
    ;normalize method1
    w_v4km_reg_avg = w_v4km_reg_avg - w_v4km_reg_avg_conform
    wscale_v4km = w_v4km_reg_avg*100                       ; now scale
    w_v4km_reg_vc = w_v4km_reg_avg*200
    copy_VarCoords(v_v4km_reg_avg, wscale_v4km)              ; copy coordinate variables
    rainnc_fi = addfile(rain_data(ires) +  "/sep_vars/ensemble/monthly_avg/rainnc_hr.nc", "r")
    rainnc := (rainnc_fi->rainnc_hr)*24
    rainc_fi = addfile(rain_data(ires) + "/sep_vars/ensemble/monthly_avg/rainc_hr.nc", "r")
    rainc := (rainc_fi->rainc_hr)*24
    rain_v4km = rainnc + rainc ;day
;u60km
    ires = 2
    qv_u60km_fi = addfile(mpas_data(ires) + "qv_ERA5.nc","r")
    qv_u60km = qv_u60km_fi->qv({95000:20000},{minlat:maxlat},{minlon:maxlon})
    qv_u60km&nLevels@units = "Pa"
    qv_u60km = qv_u60km*1000
    qv_u60km := dim_avg_n_Wrap(qv_u60km,2)

    theta_u60km_fi = addfile(mpas_data(ires) + "theta_ERA5.nc","r")
    theta_u60km = theta_u60km_fi->theta({95000:20000},{minlat:maxlat},{minlon:maxlon})
    theta_u60km&nLevels@units = "Pa"
    T_u60km =  theta_u60km*(nlevels/100000.)^0.286
    T_u60km = T_u60km - 273.15

    copy_VarCoords(theta_u60km,T_u60km)
    T_u60km := dim_avg_n_Wrap(T_u60km,2)

    w_u60km_fi = addfile(mpas_data(ires) + "w_ERA5.nc","r")
    w_u60km = w_u60km_fi->w({920000:20000},{minlat:maxlat},{minlon:maxlon})
    w_u60km&nLevels@units = "Pa"
    ;w_u60km = w_u60km*100

    v_u60km_fi = addfile(mpas_data(ires) + "uReconstructMeridional_ERA5.nc","r")
    v_u60km = v_u60km_fi->uReconstructMeridional({920000:20000},{minlat:maxlat},{minlon:maxlon})
    v_u60km&nLevels@units = "Pa"


    w_u60km_reg_avg = dim_avg_n_Wrap(w_u60km, 2)
    v_u60km_reg_avg = dim_avg_n_Wrap(v_u60km, 2)
    ;w_u60km_reg_vc = w_u60km_reg_avg*200

    w_u60km_reg_avg_layer = dim_avg_n_Wrap(w_u60km_reg_avg,1)
    w_u60km_reg_avg_conform = conform(w_u60km_reg_avg,w_u60km_reg_avg_layer,0)
    ;normalize method1
    w_u60km_reg_avg = w_u60km_reg_avg - w_u60km_reg_avg_conform
    wscale_u60km = w_u60km_reg_avg*100                       ; now scale
    w_u60km_reg_vc = w_u60km_reg_avg*200
    copy_VarCoords(v_u60km_reg_avg, wscale_u60km)              ; copy coordinate variables
    rainnc_fi = addfile(rain_data(ires) +  "/sep_vars/ensemble/monthly_avg/rainnc_hr.nc", "r")
    rainnc := (rainnc_fi->rainnc_hr)*24
    rainc_fi = addfile(rain_data(ires) + "/sep_vars/ensemble/monthly_avg/rainc_hr.nc", "r")
    rainc := (rainc_fi->rainc_hr)*24
    rain_u60km = rainnc + rainc ;day

    mesh_path = "/storage/aemolcore02/jungu/mesh/"
    mesh_res = (/"u3km","rotated_4-60km_33N132E_785410","u60km","u60km"/)
    mesh_fi = addfile(mesh_path + mesh_res(0) + "/cell_fill.nc","r")
    lat_u3km = mesh_fi->latCell
    lon_u3km = mesh_fi->lonCell
    mesh_fi = addfile(mesh_path + mesh_res(1) + "/cell_fill.nc","r")
    lat_v4km = mesh_fi->latCell
    lon_v4km = mesh_fi->lonCell
    mesh_fi = addfile(mesh_path + mesh_res(2) + "/cell_fill.nc","r")
    lat_u60km = mesh_fi->latCell
    lon_u60km = mesh_fi->lonCell

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

    lat_interval = fspan(-20,50,141);0.5
    rain_region_lat = new((/4,141/),double)
    do i = 0, 140
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
    wks_name = "Figure4_lower"
    wks_type = "png"
    N_res = 3
    wks_type@wkHeight = 1024*N_res
    wks_type@wkWidth  = 1024*N_res
    wks = gsn_open_wks(wks_type, wks_name)
    ;set uniform resources
    res = True
    res@gsnDraw = False
    res@gsnFrame= False
    res@gsnAddCyclic = False
    res@gsnMaximize  = False
    res@gsnStringFont = 25
    res@gsnStringFontHeightF = 0.022
    res@gsnLeftString = ""
    res@gsnRightString= ""
    res@gsnLeftStringOrthogonalPosF = 0.0
    res@gsnRightStringOrthogonalPosF = 0.0

    res@tmXTOn = False
    res@tmYROn = False
    ;res@tiYAxisOn = False
    ;res@tmBorderThicknessF = 8.0

    res@tmXBMinorOn = True
    res@tmYLMinorOn = False

    res@tmBorderThicknessF =2.0*N_res
    res@tmXBMajorLengthF = 0.006
    res@tmXBMinorLengthF = 0.003
    res@tmXBMajorOutwardLengthF = 0.006
    res@tmXBMinorOutwardLengthF = 0.003
    res@tmXBMajorThicknessF=2.0*N_res
    res@tmXBMinorThicknessF=2.0*N_res
    res@tmYLMajorLengthF = 0.005
    res@tmYLMajorOutwardLengthF = 0.005
    res@tmYLMajorThicknessF=2.0*N_res

    res@tmXBLabelDeltaF = -0.5
    res@tmYLLabelDeltaF = -0.5
    res@tmXBLabelFontHeightF = 0.017
    res@tmYLLabelFontHeightF = 0.017
    res@tmXBLabelFont = 25
    res@tmYLLabelFont = 25


    res@tmXBMode = "Explicit"
    res@tmXBValues = ispan(-20, 50, 10)
    ;res@tmXBValues = ispan(-120, 180, 60)
    XBLabels = new(8,string)
    XBLabels1 = "~F25~" + (/20,10/)+ "~S~o~N~S"
    XBLabels2 = "~F25~EQ"
    XBLabels3 = "~F25~" + (/10,20,30,40,50/)+ "~S~o~N~N"
    XBLabels(0:1) = XBLabels1
    XBLabels(2) = XBLabels2
    XBLabels(3:7) = XBLabels3
    res@tmXBLabels = XBLabels

    levels = fspan(-1.2,1.2,13)
    ;print(levels)
    cmap = read_colormap_file("BlueRed")
    colors = new((/14,4/),double)
    colors  = cmap(28:223:15,:)
    ;levels = 
    vcres = res
    vcres@tiYAxisFontHeightF = 0.019
    vcres@tiYAxisPosition = "Center"
    vcres@tiYAxisOffsetXF = 0.0
    vcres@tiYAxisString = "~F25~" + "Pressure (hPa)"

    vcres@tmYLOn = True
    vcres@tmYLLabelsOn = True
    vcres@tmYROn = False
    vcres@tmYLMode = "Explicit"
    ;print(ispan(30000,95000,10000))
    vcres@tmYLValues = ispan(200, 950, 100)
    ;res@tmYLValues = ispan(-120, 180, 60)
    YLLabels = "~F25~" + res@tmYLValues
    vcres@tmYLLabels = YLLabels

    vcres@trYLog  = False
    vcres@trYReverse = True
    vcres@trYMinF = 210


    ;res@trXMinF = 25
    ;res@trXMaxF = 40

    res@gsnPresHgtHeightLabelOn = False ;Remove the "height" label


    vcres@cnFillOn = True
    vcres@cnLinesOn = False
    vcres@cnLineLabelsOn = False
    vcres@cnLevelSelectionMode = "ExplicitLevels"
    vcres@cnLevels = levels
    vcres@cnFillColors = colors
    vcres@lbLabelBarOn = False
    vcres@cnInfoLabelOn = False

    vcres@vcRefMagnitudeF       = 2.0                 ; define vector ref mag
    vcres@vcRefLengthF          = 0.035                ; define length of vec ref
    vcres@vcMinDistanceF        = 0.0199               ; thin out vectors
    vcres@vcGlyphStyle          = "CurlyVector";"CurlyVector"        ; turn on curly vecto
    vcres@vcLineArrowThicknessF = 1.*N_res
    vcres@vcFillArrowEdgeColor = -1
    vcres@vcFillOverEdge = False
    vcres@vcRefAnnoPerimOn          = True
    vcres@vcRefAnnoString1          = "2"
    vcres@vcRefAnnoString2          = "Reference"
    vcres@vcRefAnnoJust             = "TopLeft"
    vcres@vcRefAnnoSide             = "Top"
    vcres@vcRefAnnoOrthogonalPosF   = -1.3
    vcres@vcRefAnnoParallelPosF     = 0
    vcres@vcRefAnnoBackgroundColor  = "white"
    vcres@vcRefAnnoFont = 25
    vcres@vcRefAnnoFontHeightF = 0.019

    xyres = res
    xyres@tmYUseLeft = False
    xyres@tmYLOn = False
    xyres@tmYROn = True
    xyres@tmYRMode = "Explicit"
    xyres@tmYRValues = (/0,5,10,15/)
    xyres@tmYRLabels = "~F25~"+(/0,5,10,15/)
    xyres@tmYRMinorValues = ispan(0,16,1)
    xyres@tmYRLabelsOn = True
    xyres@tmYRLabelFont = 25
    xyres@tmXBMajorLengthF = 0.005
    xyres@tmYRMinorLengthF = 0.003
    xyres@tmYRMajorOutwardLengthF = 0.005
    xyres@tmYRMinorOutwardLengthF = 0.003
    xyres@tmYRMajorThicknessF=6.0
    xyres@tmYRMinorThicknessF=6.0

    xyres@trYMinF = 0
    xyres@trYMaxF = 16
    ;xyres@tmYRLabelFontHeightF = 0.017

    xyres@tiYAxisSide ="Right"
    xyres@tiYAxisFontHeightF = 0.018

    xyres@xyDashPatterns  = (/0,0/) ; Make curves all solid except offical forecast
    xyres@xyMarkLineMode = "Lines"
    xyres@xyLineThicknesses = (/2,3/)*N_res

    lat_interval = fspan(-20,50,141);0.5
    xyres@trXMinF = -20
    xyres@trXMaxF = 50



    ;vcres@gsnXRefLine = 0
    ;vcres@gsnXRefLineThicknessF = 5.
    ;stream_plot = gsn_csm_streamline(wks, v_reg_avg, w_reg_avg, stres)
    ;stream_plot = gsn_csm_vector(wks, v_reg_avg(:,::10), wscale(:,::10), vcres)
    ;stream_plot = gsn_csm_vector(wks, wscale(:,::10), v_reg_avg(:,::10), vcres)
    ;stream_plot = gsn_csm_vector(wks, v_reg_avg, wscale, vcres)
    ;plot = gsn_csm_streamline(wks, v_reg_avg_H, wscale_H, stres)
    plot = new(3,graphic)
    plot_xy = new(3,graphic)
    plot_add_temp = new(3,graphic)

    vcres@gsnLeftString = "(d) U3KM"
    plot(0)= gsn_csm_pres_hgt_vector(wks, wscale_u3km, v_u3km_reg_avg, w_u3km_reg_vc, vcres)
    xy_colors := (/"firebrick1","Black"/)
    xyres@xyLineColors   = xy_colors
    xyres@tiYAxisString = ""
    plot_xy(0) = gsn_csm_xy(wks,lat_interval,rain_region_lat(0:3:3,:),xyres)
    anno_id1 = gsn_add_annotation(plot(0), plot_xy(0), False)

    vcres@gsnLeftString = "(e) V4KM"
    vcres@vcRefAnnoOn = False
    vcres@tiYAxisOn = False
    vcres@tiYAxisString = ""
    plot(1)= gsn_csm_pres_hgt_vector(wks, wscale_v4km, v_v4km_reg_avg, w_v4km_reg_vc, vcres)
    xy_colors := (/"navyblue","Black"/)
    xyres@xyLineColors   = xy_colors
    plot_xy(1) = gsn_csm_xy(wks,lat_interval,rain_region_lat(1:3:2,:),xyres)
    anno_id2 = gsn_add_annotation(plot(1), plot_xy(1), False)

    vcres@gsnLeftString = "(f) U60KM"
    plot(2)= gsn_csm_pres_hgt_vector(wks, wscale_u60km, v_u60km_reg_avg, w_u60km_reg_vc, vcres)
    xy_colors := (/"orange","Black"/)
    xyres@xyLineColors   = xy_colors
    xyres@tiYAxisString = "~F25~Precipitation (mm/day)"
    plot_xy(2) = gsn_csm_xy(wks,lat_interval,rain_region_lat(2:3,:),xyres)
    anno_id2 = gsn_add_annotation(plot(2), plot_xy(2), False)

    lnres = True
    lnres@gsLineColor = "Purple"
    lnres@gsLineThicknessF = 4.5*N_res
    lnres@gsLineDashPattern = 0
    ln_lat = (/950,100/)
    ln_lon = (/0,0/)

    dum10 = gsn_add_polyline(wks,plot(0),ln_lon,ln_lat,lnres)
    dum11 = gsn_add_polyline(wks,plot(1),ln_lon,ln_lat,lnres)
    dum12 = gsn_add_polyline(wks,plot(2),ln_lon,ln_lat,lnres)
    ln_lon = (/30,30/)
    dum13 = gsn_add_polyline(wks,plot(0),ln_lon,ln_lat,lnres)
    dum14 = gsn_add_polyline(wks,plot(1),ln_lon,ln_lat,lnres)
    dum15 = gsn_add_polyline(wks,plot(2),ln_lon,ln_lat,lnres)
    ;dum4 = gsn_add_polyline(wks,plot(1),ln_lon,ln_lat,lnres)
    ;dum5 = gsn_add_polyline(wks,plot(2),ln_lon,ln_lat,lnres)
    ;plot= gsn_csm_pres_hgt_vector(wks, v_reg_avg, v_reg_avg(:,::10), wscale(:,::10), vcres)
    ;plot= gsn_csm_pres_hgt_streamline(wks, v_reg_avg, v_reg_avg(:,::10), wscale(:,::10), stres)
    ;plot= gsn_csm_pres_hgt_streamline(wks, v_reg_avg, v_reg_avg, wscale, stres)

    ;Create common label
    lbres = True
    lbres@vpXF = 0.2
    lbres@vpYF = 0.4
    ;lbres@vpYF = 0.30
    lbres@vpWidthF = 0.6
    lbres@vpHeightF= 0.05

    lbres@lbPerimOn = False
    lbres@lbBoxLinesOn = False
    lbres@lbBoxSeparatorLinesOn = False
    lbres@lbBoxLineThicknessF = 1.2*N_res
    lbres@lbFillColors  := colors
    lbres@lbOrientation = "horizontal"
    lbres@lbMonoFillPattern = True
    lbres@lbLabelFontHeightF = 0.014
    lbres@lbLabelAlignment   = "InteriorEdges"
    lbres@lbTitlePosition = "Bottom"
    lbres@lbTitleFontHeightF = 0.015
    lbres@lbTitleOffsetF = 0.2
    lbres@lbTitleExtentF = 0.25
    lbres@lbTitleString = "~F25~Vertical speed (10~S~-2~N~ m/s)";optional
    ;lbres@lbTitleString = "";optional
    ;lbres@lbLabelStride = 5
    nboxes = dimsizes(colors)
    labels = "~F25~"+levels
    lbid = gsn_create_labelbar(wks,nboxes,labels,lbres)
    draw(lbid)
;Create panel
    resP = True
    resP@gsnPanelLabelBar = False;Create label self
    resP@gsnPanelRowSpec = True
    resP@gsnPanelCenter = True
    resP@gsnPanelBottom = 0.12
    ;resP@gsnPanelYWhiteSpacePercent = 5
    ;drawNDCGrid(wks)
    gsn_panel(wks,plot,(/3/),resP)


;-----------------------------
    wallClockElapseTime(wcStrtGraphics, "Graphics", 0)
    wallClockElapseTime(wcStrt, "Processing and Graphics", 0)
end
