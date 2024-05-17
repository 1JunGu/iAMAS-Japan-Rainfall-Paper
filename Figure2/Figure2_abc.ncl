begin
    dq = str_get_dq()
    date_cmd   = "date +" + dq + "%a %b %d %H:%M:%S %Z %Y" + dq
    wcStrt = systemfunc(date_cmd)
;---Processing----------------
    res_path = (/"u3km","v4-60km_33N132E_785410","u60km","u60km_100s"/)

    mpas_data = "/storage/aemolcore02/jungu/2020_Kyushu/" + res_path + "/ensemble/mpas_out/monthly_avg/sep_vars/ERA5/"

    rain_data = "/storage/aemolcore02/jungu/2020_Kyushu/"

    minlon = 122
    maxlon = 154

    ires = 0
    qc_fi1 = addfile(mpas_data(ires) + "qv_ERA5.nc","r")
    qc1 = qc_fi1->qv({95000:5000},{-20:50},{minlon:maxlon})
    qc1_region = dim_avg_n_Wrap(qc1,2)
    qc1_region&nLevels@units = "Pa"

    w_fi1 = addfile(mpas_data(ires) + "w_ERA5.nc","r")
    w1 = w_fi1->w({95000:5000},{-20:50},{minlon:maxlon})
    w1_region = dim_avg_n_Wrap(w1,2)
    w1_region&nLevels@units = "Pa"

    rainnc_fi = addfile(rain_data+res_path(ires) +  "/sep_vars/ensemble/monthly_avg/rainnc_hr.nc", "r")
    rainnc = (rainnc_fi->rainnc_hr)*24
    rainc_fi = addfile(rain_data+res_path(ires) + "/sep_vars/ensemble/monthly_avg/rainc_hr.nc", "r")
    rainc = (rainc_fi->rainc_hr)*24
    rain_u3km = rainnc + rainc ;day

    ires = 1
    qc_fi2 = addfile(mpas_data(ires) + "qv_ERA5.nc","r")
    qc2 = qc_fi2->qv({95000:5000},{-20:50},{minlon:maxlon})
    qc2_region = dim_avg_n_Wrap(qc2,2)
    qc2_region&nLevels@units = "Pa"

    w_fi2 = addfile(mpas_data(ires) + "w_ERA5.nc","r")
    w2 = w_fi2->w({95000:5000},{-20:50},{minlon:maxlon})
    w2_region = dim_avg_n_Wrap(w2,2)
    w2_region&nLevels@units = "Pa"

    rainnc_fi = addfile(rain_data+res_path(ires) +  "/sep_vars/ensemble/monthly_avg/rainnc_hr.nc", "r")
    rainnc := (rainnc_fi->rainnc_hr)*24
    rainc_fi = addfile(rain_data+res_path(ires) + "/sep_vars/ensemble/monthly_avg/rainc_hr.nc", "r")
    rainc := (rainc_fi->rainc_hr)*24
    rain_v4km = rainnc + rainc ;day



    ires = 2
    qc_fi3 = addfile(mpas_data(ires) + "qv_ERA5.nc","r")
    qc3 = qc_fi3->qv({95000:5000},{-20:50},{minlon:maxlon})
    qc3_region = dim_avg_n_Wrap(qc3,2)
    qc3_region&nLevels@units = "Pa"

    w_fi3 = addfile(mpas_data(ires) + "w_ERA5.nc","r")
    w3 = w_fi3->w({95000:5000},{-20:50},{minlon:maxlon})
    w3_region = dim_avg_n_Wrap(w3,2)
    w3_region&nLevels@units = "Pa"

    rainnc_fi = addfile(rain_data+res_path(ires) +  "/sep_vars/ensemble/monthly_avg/rainnc_hr.nc", "r")
    rainnc := (rainnc_fi->rainnc_hr)*24
    rainc_fi = addfile(rain_data+res_path(ires) + "/sep_vars/ensemble/monthly_avg/rainc_hr.nc", "r")
    rainc := (rainc_fi->rainc_hr)*24
    rain_u60km = rainnc + rainc ;day

    qc_diff1  = (qc1_region - qc3_region)/qc3_region
    copy_VarCoords(qc1_region,qc_diff1)
    w_diff1 = (w1_region - w3_region)
    copy_VarCoords(w1_region,w_diff1)
    w_diff1@_FillValue = -999.

    qc_diff2  = (qc2_region - qc3_region)/qc3_region
    copy_VarCoords(qc2_region,qc_diff2)
    w_diff2 = (w2_region - w3_region)
    copy_VarCoords(w2_region,w_diff2)
    w_diff2@_FillValue = -999.

    qc_diff3  = (qc1_region - qc2_region)/qc2_region
    copy_VarCoords(qc3_region,qc_diff3)
    w_diff3 = (w1_region - w2_region)
    copy_VarCoords(w1_region,w_diff3)
    w_diff3@_FillValue = -999.

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

    ;select region
    minlat = -21.
    maxlat = 41.

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
    rain_region_lat = new((/3,121/),double)
    do i = 0, 120
        index_lat := ind(lat_u3km_region.ge.lat_interval(i)-0.25.and.lat_u3km_region.le.lat_interval(i)+0.25)
        rain_region_lat(0,i) = dim_avg_n_Wrap(rain_u3km_region(index_lat), 0)
        index_v4km_lat := ind(lat_v4km_region.ge.lat_interval(i)-0.25.and.lat_v4km_region.le.lat_interval(i)+0.25)
        rain_region_lat(1,i) = dim_avg_n_Wrap(rain_v4km_region(index_v4km_lat), 0)
        index_u60km_lat := ind(lat_u60km_region.ge.lat_interval(i)-0.25.and.lat_u60km_region.le.lat_interval(i)+0.25)
        rain_region_lat(2,i) = dim_avg_n_Wrap(rain_u60km_region(index_u60km_lat), 0)
    end do

;-----------------------------
    wallClockElapseTime(wcStrt, "Processing", 0)
    wcStrtGraphics = systemfunc(date_cmd)
;---Graphics------------------
    wks_name = "Figure2_abc"
    wks_type = "png"
    N_res = 4
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
    res@gsnLeftString = ""
    res@gsnRightString= ""
    res@gsnLeftStringOrthogonalPosF = 0.0
    res@gsnRightStringOrthogonalPosF = 0.0

    ;res@vpHeightF = 0.6
    ;res@vpWidthF = 0.8
    ;res@vpXF = 0.11
    ;res@vpYF = 0.8


    res@tmXTOn = False
    res@tmYROn = False
    ;res@tiYAxisOn = False
    ;res@tmBorderThicknessF = 8.0

    res@tmXBMinorOn = True
    res@tmYLMinorOn = False

    res@tmBorderThicknessF =6.0
    res@tmXBMajorLengthF = 0.005
    res@tmXBMinorLengthF = 0.003
    res@tmXBMajorOutwardLengthF = 0.005
    res@tmXBMinorOutwardLengthF = 0.003
    res@tmXBMajorThicknessF=6.0
    res@tmXBMinorThicknessF=6.0
    res@tmYLMajorLengthF = 0.005
    res@tmYLMajorOutwardLengthF = 0.005
    res@tmYLMajorThicknessF=6.0

    res@tmXBLabelDeltaF = -0.5
    res@tmYLLabelDeltaF = -0.5
    res@tmXBLabelFontHeightF = 0.017
    res@tmYLLabelFontHeightF = 0.017
    res@tmXBLabelFont = 25
    res@tmYLLabelFont = 25

    res@tmXBMode = "Explicit"
    res@tmXBMinorValues = ispan(24, 41, 1)
    res@tmXBValues = ispan(25, 40, 5)
    ;res@tmXBValues = ispan(-120, 180, 60)
    XBLabels = "~F25~" + (/25,30,35,40/)+ "~S~o~N~N"
    res@tmXBLabels = XBLabels

    vcres = res
    vcres@tmYLOn = True
    vcres@tmYLLabelsOn = True
    vcres@tmYROn = False
    vcres@tmYLMode = "Explicit"
    vcres@tmYLValues = ispan(100, 950, 100)
    ;res@tmYLValues = ispan(-120, 180, 60)
    YLLabels = "~F25~" + vcres@tmYLValues
    vcres@tmYLLabels = YLLabels

    vcres@trYLog  = False
    vcres@trYReverse = True
    vcres@trYMinF = 90


    vcres@tiYAxisString = "~F25~" + "Pressure (hPa)"
    vcres@tiYAxisFontHeightF = 0.019
    vcres@tiYAxisPosition = "Center"
    vcres@tiYAxisOffsetXF = -0.01

    vcres@trXMinF = 24.5
    vcres@trXMaxF = 40.5

    ;levels = (/-0.5,-0.4,-0.3,-0.2,-0.1,0.1,0.2,0.3,0.4,0.5/)
    levels = (/-0.5,-0.4,-0.2,-0.1,-0.01,0.01,0.1,0.2,0.4,0.5/)
    ;cmap = read_colormap_file("WhiteBlue")
    cmap = read_colormap_file("CBR_drywet")
    colors = new((/11,4/),double)
    colors  = cmap(:,:)
    ;levels = 
    vcres@cnFillOn = True
    vcres@cnLinesOn = False
    vcres@cnLineLabelsOn = False
    vcres@cnLevelSelectionMode = "ExplicitLevels"
    vcres@cnLevels = levels
    vcres@cnFillColors = colors
    vcres@lbLabelBarOn = False
    vcres@cnInfoLabelOn = False

    vcres@gsnPresHgtHeightLabelOn = False ;Remove the "height" label

    vcres@vcRefMagnitudeF       = .01                 ; define vector ref mag
    vcres@vcRefLengthF          = 0.015                ; define length of vec ref
    vcres@vcMinDistanceF        = 0.0199               ; thin out vectors
    vcres@vcGlyphStyle          = "FillArrow"        ; turn on curly vecto
    vcres@vcFillArrowEdgeColor = -1
    vcres@vcFillOverEdge = False
    vcres@vcRefAnnoFont = 25
    vcres@vcRefAnnoJust = "TopRight"
    vcres@vcRefAnnoOn = False

    w_diff1_add = w_diff1
    w_diff1_add = 0
    w_diff1 = where(abs(w_diff1).le.0.002,w_diff1@_FillValue,w_diff1)
    plot = new(3,graphic)
    vcres@gsnLeftString = "(a) U3KM - U60KM"
    plot(0) = gsn_csm_pres_hgt_vector(wks,qc_diff1,w_diff1_add,w_diff1,vcres)
    vcres@gsnLeftString = "(b) V4KM - U60KM"
    vcres@tiYAxisString = ""
    plot(1) = gsn_csm_pres_hgt_vector(wks,qc_diff2,w_diff1_add,w_diff2,vcres)
    vcres@gsnLeftString = "(c) U3KM - V4KM"
    plot(2) = gsn_csm_pres_hgt_vector(wks,qc_diff3,w_diff1_add,w_diff3,vcres)

    xyres = res
    xyres@tmYUseLeft = False
    xyres@tmYLOn = False
    xyres@tmYROn = True
    xyres@tmYRMode = "Explicit"
    xyres@tmYRValues = (/0,5,10/)
    xyres@tmYRLabels = "~F25~"+(/0,5,10/)
    xyres@tmYRMinorValues = ispan(0,14,1)
    xyres@tmYRLabelsOn = True
    xyres@tmYRLabelFont = 25
    xyres@tmXBMajorLengthF = 0.005
    xyres@tmYRMinorLengthF = 0.003
    xyres@tmYRMajorOutwardLengthF = 0.005
    xyres@tmYRMinorOutwardLengthF = 0.003
    xyres@tmYRMajorThicknessF=6.0
    xyres@tmYRMinorThicknessF=6.0

    xyres@trYMinF = 0
    xyres@trYMaxF = 14
    ;xyres@tmYRLabelFontHeightF = 0.017

    xyres@tiYAxisSide ="Right"
    xyres@tiYAxisFontHeightF = 0.018

    xyres@xyDashPatterns  = (/0,0/) ; Make curves all solid except offical forecast
    xyres@xyMarkLineMode = "Lines"
    xyres@xyLineThicknesses = (/4,4/)*N_res
    xyres@tiYAxisString = "~F25~Precipitation (mm/day)"

    lat_interval = fspan(-20,40,121);0.5
    xyres@trXMinF = 24.5
    xyres@trXMaxF = 40.5
    plot_xy = new(3,graphic)
    xy_colors := (/"firebrick1","navyblue"/)
    xyres@xyLineColors   = xy_colors
    plot_xy(0) = gsn_csm_xy(wks,lat_interval,rain_region_lat(0:2:2,:),xyres)
    anno_id0 = gsn_add_annotation(plot(0), plot_xy(0), False)
    xy_colors := (/"navyblue","orange"/)
    xyres@xyLineColors   = xy_colors
    xyres@tiYAxisString = ""
    plot_xy(1) = gsn_csm_xy(wks,lat_interval,rain_region_lat(1:2,:),xyres)
    anno_id1 = gsn_add_annotation(plot(1), plot_xy(1), False)
    xy_colors := (/"firebrick1","orange"/)
    xyres@xyLineColors   = xy_colors
    plot_xy(2) = gsn_csm_xy(wks,lat_interval,rain_region_lat(0:1,:),xyres)
    anno_id2 = gsn_add_annotation(plot(2), plot_xy(2), False)

    ;Create common label
    lbres = True
    lbres@vpXF = 0.1
    lbres@vpYF = 0.42
    ;lbres@vpYF = 0.30
    lbres@vpWidthF = 0.8
    lbres@vpHeightF= 0.07
    lbres@lbPerimOn = False
    lbres@lbBoxLinesOn = False
    lbres@lbBoxSeparatorLinesOn = False
    lbres@lbBoxLineThicknessF = 1.2*N_res
    lbres@lbFillColors  := colors
    lbres@lbOrientation = "horizontal"
    lbres@lbMonoFillPattern = True
    lbres@lbLabelFontHeightF = 0.014
    lbres@lbLabelAlignment   = "InteriorEdges"
    lbres@lbTitleOn = False
    lbres@lbTitlePosition = "Bottom"
    lbres@lbTitleFontHeightF = 0.015
    lbres@lbTitleOffsetF = 0.2
    lbres@lbTitleExtentF = 0.25
    lbres@lbTitleString = "~F25~Percentage difference (%)";optional
    lbres@lbLabelStride = 1
    nboxes := dimsizes(colors)
    labels := "~F25~"+levels*100
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

    cpu_end_time = get_cpu_time()
;-----------------------------
    wallClockElapseTime(wcStrtGraphics, "Graphics", 0)
    wallClockElapseTime(wcStrt, "Processing and Graphics", 0)
end
