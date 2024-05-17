begin
    dq = str_get_dq()
    date_cmd   = "date +" + dq + "%a %b %d %H:%M:%S %Z %Y" + dq
    wcStrt = systemfunc(date_cmd)

;---Processing----------------
    res_list = (/"u3km","v4-60km_33N132E_785410","u60km"/)
    mpas_data = "/storage/aemolcore02/jungu/2020_Kyushu/" + res_list + "/ensemble/mpas_out/monthly_avg/sep_vars/ERA5/"

    rain_data = "/storage/aemolcore02/jungu/2020_Kyushu/"

    minlat = -20.
    maxlat = 50.
    minlon = 122.
    maxlon = 154.

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
;-----------------------------
    wallClockElapseTime(wcStrt, "Processing", 0)
    wcStrtGraphics = systemfunc(date_cmd)
;---Graphics------------------
    wks_name = "MeridionalCir_u3km_reg_norm2"
    wks_type = "png"
    N_res = 1
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

    res@tmBorderThicknessF =6.0
    res@tmXBMajorLengthF = 0.006
    res@tmXBMinorLengthF = 0.003
    res@tmXBMajorOutwardLengthF = 0.006
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

    res@tmYLOn = True
    res@tmYLLabelsOn = True
    res@tmYROn = False
    res@tmYLMode = "Explicit"
    ;print(ispan(30000,95000,10000))
    res@tmYLValues = ispan(200, 950, 100)
    ;res@tmYLValues = ispan(-120, 180, 60)
    YLLabels = "~F25~" + res@tmYLValues
    res@tmYLLabels = YLLabels

    res@trYLog  = False
    res@trYReverse = True
    res@trYMinF = 210

    res@tiYAxisFontHeightF = 0.019
    res@tiYAxisPosition = "Center"
    res@tiYAxisOffsetXF = -0.01

    ;res@trXMinF = 25
    ;res@trXMaxF = 40

    res@gsnPresHgtHeightLabelOn = False ;Remove the "height" label

    levels = fspan(-1.2,1.2,13)
    ;print(levels)
    cmap = read_colormap_file("BlueRed")
    colors = new((/14,4/),double)
    colors  = cmap(28:223:15,:)
    ;levels = 
    vcres = res
    vcres@tiYAxisString = "~F25~" + "Pressure (hPa)"
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
    vcres@vcLineArrowThicknessF = 2.*N_res
    vcres@vcFillArrowEdgeColor = -1
    vcres@vcFillOverEdge = False
    vcres@vcRefAnnoPerimOn          = True
    vcres@vcRefAnnoString1          = "5"
    vcres@vcRefAnnoString2          = "Reference"
    vcres@vcRefAnnoJust             = "TopLeft"
    vcres@vcRefAnnoSide             = "Top"
    vcres@vcRefAnnoOrthogonalPosF   = -1.3
    vcres@vcRefAnnoParallelPosF     = 0
    vcres@vcRefAnnoBackgroundColor  = "white"
    vcres@vcRefAnnoFont = 25
    vcres@vcRefAnnoFontHeightF = 0.019

    qres = res
    qres@cnFillOn = False
    qres@cnLinesOn = True
    qres@cnLineLabelsOn = True
    qres@cnLevelSelectionMode = "ExplicitLevels"
    qres@cnLevels = (/3,6,9,12,15/)
    qres@cnLineLabelStrings ="~F25~" +  qres@cnLevels + " g/kg"
    qres@cnLineLabelFont = 25
    qres@cnLineLabelFontHeightF = 0.016
    qres@cnExplicitLineLabelsOn  = True
    qres@cnLineLabelInterval = 1
    qres@cnLineThicknessF = 3.0*N_res
    qres@cnLineColor = "Purple"
    qres@cnLineLabelFontColor = "Purple"
    ;qres@cnLineBackgroundColor = 
    qres@cnLineLabelBackgroundColor = -1
    ;qres@cnFillColors = colors
    ;qres@lbLabelBarOn = False
    ;qres@cnInfoLabelOn = False
    qres@cnInfoLabelOn = False
    qres@cnLineLabelPlacementMode = "Constant"

    tres = qres
    tres@cnLevels := fspan(-20,20,5)
    tres@cnLineLabelStrings :="~F25~" +  tres@cnLevels
    tres@cnLineColor = "RoyalBlue"
    tres@cnLineLabelFontColor = "RoyalBlue"
    tres@cnLineDashPattern = 1
    tres@cnMonoLineThickness = False
    tres@cnLineThicknesses = (/4.5,4.5,6,4.5,4.5,4.5/)*N_res


    ;vcres@gsnXRefLine = 0
    ;vcres@gsnXRefLineThicknessF = 5.
    ;stream_plot = gsn_csm_streamline(wks, v_reg_avg, w_reg_avg, stres)
    ;stream_plot = gsn_csm_vector(wks, v_reg_avg(:,::10), wscale(:,::10), vcres)
    ;stream_plot = gsn_csm_vector(wks, wscale(:,::10), v_reg_avg(:,::10), vcres)
    ;stream_plot = gsn_csm_vector(wks, v_reg_avg, wscale, vcres)
    ;plot = gsn_csm_streamline(wks, v_reg_avg_H, wscale_H, stres)
    plot = new(3,graphic)
    plot_add = new(3,graphic)
    plot_add_temp = new(3,graphic)

    plot(0)= gsn_csm_pres_hgt_vector(wks, wscale_u3km, v_u3km_reg_avg, w_u3km_reg_vc, vcres)
    plot_add(0) = gsn_csm_pres_hgt(wks,qv_u3km,qres)
    plot_add_temp(0) = gsn_csm_pres_hgt(wks,T_u3km,tres)
    anno_id = gsn_add_annotation(plot(0),plot_add(0),False)
    anno_id2 = gsn_add_annotation(plot(0),plot_add_temp(0),False)

    lnres = True
    lnres@gsLineColor = "Purple"
    lnres@gsLineThicknessF = 6.5*N_res
    lnres@gsLineDashPattern = 0
    ln_lat = (/950,100/)
    ln_lon = (/0,0/)

    dum10 = gsn_add_polyline(wks,plot(0),ln_lon,ln_lat,lnres)
    ln_lon = (/30,30/)
    dum11 = gsn_add_polyline(wks,plot(0),ln_lon,ln_lat,lnres)
    ;dum4 = gsn_add_polyline(wks,plot(1),ln_lon,ln_lat,lnres)
    ;dum5 = gsn_add_polyline(wks,plot(2),ln_lon,ln_lat,lnres)
    ;plot= gsn_csm_pres_hgt_vector(wks, v_reg_avg, v_reg_avg(:,::10), wscale(:,::10), vcres)
    ;plot= gsn_csm_pres_hgt_streamline(wks, v_reg_avg, v_reg_avg(:,::10), wscale(:,::10), stres)
    ;plot= gsn_csm_pres_hgt_streamline(wks, v_reg_avg, v_reg_avg, wscale, stres)

    ;Create common label
    lbres = True
    lbres@vpXF = 0.2
    lbres@vpYF = 0.14
    ;lbres@vpYF = 0.30
    lbres@vpWidthF = 0.6
    lbres@vpHeightF= 0.05

    lbres@lbPerimOn = False
    lbres@lbBoxLinesOn = True
    lbres@lbBoxSeparatorLinesOn = False
    lbres@lbBoxLineThicknessF = 1.2*N_res
    lbres@lbFillColors  := colors
    lbres@lbOrientation = "horizontal"
    lbres@lbMonoFillPattern = True
    lbres@lbLabelFontHeightF = 0.016
    lbres@lbLabelAlignment   = "InteriorEdges"
    lbres@lbTitlePosition = "Bottom"
    lbres@lbTitleFontHeightF = 0.019
    lbres@lbTitleOffsetF = 0.2
    lbres@lbTitleExtentF = 0.25
    lbres@lbTitleString = "~F25~Vertical speed (10~S~-2~N~ m/s)";optional
    ;lbres@lbLabelStride = 5
    nboxes = dimsizes(colors)
    labels = "~F25~"+levels
    lbid = gsn_create_labelbar(wks,nboxes,labels,lbres)
    draw(lbid)
    draw(plot)
    frame(wks)

    
;-----------------------------
    wallClockElapseTime(wcStrtGraphics, "Graphics", 0)
    wallClockElapseTime(wcStrt, "Processing and Graphics", 0)
end
