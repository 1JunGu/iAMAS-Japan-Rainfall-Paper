begin
    ;plot single 2D variable
    ;panel: uniform 3km variable 4km uniform 60km
    cpu_start_time = get_cpu_time()
    ;start_time     = toint(systemfunc("date +%s"))

    var_prefix = "./"
    res_list = (/"u3km","v4-60km_33N132E_785410","u60km"/)

    mpas_data = "/storage/aemolcore02/jungu/2020_Kyushu/" + res_list + "/ensemble/mpas_out/monthly_avg/sep_vars/ERA5/"
    rain_data = "/storage/aemolcore02/jungu/2020_Kyushu/"

    minlat = 25.
    maxlat = 40.
    minlon = 132.
    maxlon = 132.

    ;threshold = 250;IVT
    g = 9.80665

    ;u3km
    f_u3km = addfile(var_prefix + res_list(0) + "_moisture_flux.nc", "r")
    ;MFC_u3km = MFC_u3km*1e4
    IUQ_u3km  = f_u3km->uq(:,{minlat:maxlat},{minlon})
    IUQ_u3km = IUQ_u3km*1000/g
    IUQ_u3km&nLevels@units = "Pa"

    ires = 0
    qv_u3km_fi = addfile(mpas_data(ires) + "qv_ERA5.nc","r")
    qv_u3km = qv_u3km_fi->qv({95000:30000},{minlat:maxlat},{minlon})
    ;qv_u3km_region = dim_avg_n_Wrap(qc1,2)
    qv_u3km&nLevels@units = "Pa"
    qv_u3km = qv_u3km*1000

    theta_u3km_fi = addfile(mpas_data(ires) + "theta_ERA5.nc","r")
    theta_u3km = theta_u3km_fi->theta({95000:30000},{minlat:maxlat},{minlon})
    ;theta_u3km_region = dim_avg_n_Wrap(qc1,2)
    theta_u3km&nLevels@units = "Pa"
    nlevels = theta_u3km&nLevels
    nlevels := conform(theta_u3km,nlevels,0)
    T_u3km =  theta_u3km*(nlevels/100000.)^0.286
    T_u3km = T_u3km - 273.15

    copy_VarCoords(qv_u3km,T_u3km)

    w_u3km_fi = addfile(mpas_data(ires) + "w_ERA5.nc","r")
    w_u3km = w_u3km_fi->w({95000:30000},{minlat:maxlat},{minlon})
    w_u3km&nLevels@units = "Pa"
    w_u3km = w_u3km*100

    v_u3km_fi = addfile(mpas_data(ires) + "uReconstructMeridional_ERA5.nc","r")
    v_u3km = v_u3km_fi->uReconstructMeridional({95000:30000},{minlat:maxlat},{minlon})
    v_u3km&nLevels@units = "Pa"

    ;v4km
    f_v4km = addfile(var_prefix + res_list(1) + "_moisture_flux.nc", "r")
    ;MFC_v4km = MFC_v4km*1e4
    IUQ_v4km  = f_v4km->uq(:,{minlat:maxlat},{minlon})
    ;IVQ_v4km  = f_v4km->vq
    IUQ_v4km = IUQ_v4km*1000/g
    IUQ_v4km&nLevels@units = "Pa"

    ires = 1
    qv_v4km_fi = addfile(mpas_data(ires) + "qv_ERA5.nc","r")
    qv_v4km = qv_v4km_fi->qv({95000:30000},{minlat:maxlat},{minlon})
    ;qv_v4km_region = dim_avg_n_Wrap(qc1,2)
    qv_v4km&nLevels@units = "Pa"
    qv_v4km = qv_v4km*1000

    theta_v4km_fi = addfile(mpas_data(ires) + "theta_ERA5.nc","r")
    theta_v4km = theta_v4km_fi->theta({95000:30000},{minlat:maxlat},{minlon})
    ;theta_v4km_region = dim_avg_n_Wrap(qc1,2)
    theta_v4km&nLevels@units = "Pa"
    T_v4km =  theta_v4km*(nlevels/100000.)^0.286
    T_v4km = T_v4km - 273.15
    copy_VarCoords(qv_v4km,T_v4km)

    w_v4km_fi = addfile(mpas_data(ires) + "w_ERA5.nc","r")
    w_v4km = w_v4km_fi->w({95000:30000},{minlat:maxlat},{minlon})
    w_v4km&nLevels@units = "Pa"
    w_v4km = w_v4km*100

    v_v4km_fi = addfile(mpas_data(ires) + "uReconstructMeridional_ERA5.nc","r")
    v_v4km = v_v4km_fi->uReconstructMeridional({95000:30000},{minlat:maxlat},{minlon})
    v_v4km&nLevels@units = "Pa"

;u60km
    f_u60km = addfile(var_prefix + res_list(2) + "_moisture_flux.nc", "r")
    ;MFC_u60km = MFC_u60km*1e4
    IUQ_u60km  = f_u60km->uq(:,{minlat:maxlat},{minlon})
    ;IVQ_u60km  = f_u60km->vq
    IUQ_u60km = IUQ_u60km*1000/g
    IUQ_u60km&nLevels@units = "Pa"

    ires = 2
    qv_u60km_fi = addfile(mpas_data(ires) + "qv_ERA5.nc","r")
    qv_u60km = qv_u60km_fi->qv({95000:30000},{minlat:maxlat},{minlon})
    ;qv_u60km_region = dim_avg_n_Wrap(qc1,2)
    qv_u60km&nLevels@units = "Pa"
    qv_u60km = qv_u60km*1000

    theta_u60km_fi = addfile(mpas_data(ires) + "theta_ERA5.nc","r")
    theta_u60km = theta_u60km_fi->theta({95000:30000},{minlat:maxlat},{minlon})
    ;theta_u60km_region = dim_avg_n_Wrap(qc1,2)
    theta_u60km&nLevels@units = "Pa"
    T_u60km =  theta_u60km*(nlevels/100000.)^0.286
    T_u60km = T_u60km - 273.15
    copy_VarCoords(qv_u60km,T_u60km)

    w_u60km_fi = addfile(mpas_data(ires) + "w_ERA5.nc","r")
    w_u60km = w_u60km_fi->w({95000:30000},{minlat:maxlat},{minlon})
    w_u60km&nLevels@units = "Pa"
    w_u60km = w_u60km*100

    v_u60km_fi = addfile(mpas_data(ires) + "uReconstructMeridional_ERA5.nc","r")
    v_u60km = v_u60km_fi->uReconstructMeridional({95000:30000},{minlat:maxlat},{minlon})
    v_u60km&nLevels@units = "Pa"

    printVarSummary(IUQ_u60km)
    printMinMax(IUQ_v4km,1)
    printMinMax(qv_v4km,1)

;*********plot*********
    N_res = 4

    wks_type = "png"
    wks_type@wkWidth  = 1024*N_res;2048
    wks_type@wkHeight = 1024*N_res
    ;wks_type@wkPDFResolution = 6000

    ;mfc_color = new((/13,4/),"float")
    ;mfc_cmap  = read_colormap_file("MPL_BrBG")
    ;trans_color = mfc_cmap(64,:)
    ;trans_color(3) = 0

    ;mfc_color(0:5,:) = mfc_cmap(0:50:10,:)
    ;mfc_color(6,:) = trans_color
    ;mfc_color(7:12,:) = mfc_cmap(77:127:10,:)
    ;mfc_cnlevels = (/-2.5,-2,-1.5,-1,-0.5,-0.2,0.2,0.5,1,1.5,2,2.5/)/5

    colors = new((/9,4/),"float")
    cmap  = read_colormap_file("WhiteBlueGreenYellowRed")
    colors(0,:) = cmap(0,:)
    colors(1:8,:) = cmap(98:238:20,:);10 colors;space: 20
    cnlevels = (/5,6,7,8,9,10,11,12/);10

    ;set uniform resources
    res = True
    res@gsnDraw = False
    res@gsnFrame= False
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
    res@tmXBMinorValues = ispan(24, 41, 1)
    res@tmXBValues = ispan(25, 40, 5)
    ;res@tmXBValues = ispan(-120, 180, 60)
    XBLabels = "~F25~" + (/25,30,35,40/)+ "~S~o~N~N"
    res@tmXBLabels = XBLabels

    res@tmYLOn = True
    res@tmYLLabelsOn = True
    res@tmYROn = False
    res@tmYLMode = "Explicit"
    ;print(ispan(30000,95000,10000))
    res@tmYLValues = ispan(300, 950, 100)
    ;res@tmYLValues = ispan(-120, 180, 60)
    YLLabels = "~F25~" + res@tmYLValues
    res@tmYLLabels = YLLabels

    res@trYLog  = False
    res@trYReverse = True
    res@trYMinF = 310


    res@tiYAxisFontHeightF = 0.019
    res@tiYAxisPosition = "Center"
    res@tiYAxisOffsetXF = -0.01

    res@trXMinF = 25
    res@trXMaxF = 40

    res@gsnPresHgtHeightLabelOn = False ;Remove the "height" label

    ;levels = (/-0.5,-0.4,-0.3,-0.2,-0.1,0.1,0.2,0.3,0.4,0.5/)
    ;levels = 
    vcres = res
    vcres@tiYAxisString = "~F25~" + "Pressure (hPa)"
    vcres@cnFillOn = True
    vcres@cnLinesOn = False
    vcres@cnLineLabelsOn = False
    vcres@cnLevelSelectionMode = "ExplicitLevels"
    vcres@cnLevels = cnlevels
    vcres@cnFillColors = colors
    vcres@lbLabelBarOn = False
    vcres@cnInfoLabelOn = False


    vcres@vcRefMagnitudeF       = 5                ; define vector ref mag
    vcres@vcRefLengthF          = 0.02                ; define length of vec ref
    vcres@vcMinDistanceF        = 0.0199               ; thin out vectors
    vcres@vcGlyphStyle          = "FillArrow"        ; turn on curly vecto
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

    ;plot = gsn_csm_pres_hgt_vector(wks,IUQ_v4km,v_v4km,w_v4km,vcres)
    ;plot = gsn_csm_pres_hgt_vector(wks,IUQ_u60km,v_u60km,w_u60km,vcres)

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

    plot_name = "Figure2_ghi"
    wks = gsn_open_wks(wks_type,plot_name)

    plot = new(3,graphic)
    plot_add = new(3,graphic)
    plot_add_temp = new(3,graphic)

    vcres@gsnLeftString = "(g) U3KM"
    plot(0) = gsn_csm_pres_hgt_vector(wks,IUQ_u3km,v_u3km,w_u3km,vcres)
    plot_add(0) = gsn_csm_pres_hgt(wks,qv_u3km,qres)
    plot_add_temp(0) = gsn_csm_pres_hgt(wks,T_u3km,tres)
    anno_id = gsn_add_annotation(plot(0),plot_add(0),False)
    anno_id2 = gsn_add_annotation(plot(0),plot_add_temp(0),False)

    vcres@vcRefAnnoOn = False
    vcres@tiYAxisString = ""
    vcres@gsnLeftString = "(h) V4KM"
    plot(1) = gsn_csm_pres_hgt_vector(wks,IUQ_v4km,v_v4km,w_v4km,vcres)
    plot_add(1) = gsn_csm_pres_hgt(wks,qv_v4km,qres)
    plot_add_temp(1) = gsn_csm_pres_hgt(wks,T_v4km,tres)
    anno_id1 = gsn_add_annotation(plot(1),plot_add(1),False)
    anno_id12 = gsn_add_annotation(plot(1),plot_add_temp(1),False)

    vcres@gsnLeftString = "(i) U60KM"
    plot(2) = gsn_csm_pres_hgt_vector(wks,IUQ_u60km,v_u60km,w_u60km,vcres)
    plot_add(2) = gsn_csm_pres_hgt(wks,qv_u60km,qres)
    plot_add_temp(2) = gsn_csm_pres_hgt(wks,T_u60km,tres)
    anno_id2 = gsn_add_annotation(plot(2),plot_add(2),False)
    anno_id22 = gsn_add_annotation(plot(2),plot_add_temp(2),False)


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
    lbres@lbOrientation = "Horizontal"
    lbres@lbMonoFillPattern = True
    lbres@lbLabelFontHeightF = 0.014
    lbres@lbLabelAlignment   = "InteriorEdges"
    lbres@lbTitlePosition = "Bottom"
    lbres@lbTitleJust = "TopCenter"
    lbres@lbTitleFontHeightF = 0.015
    lbres@lbTitleOffsetF = 0.2
    lbres@lbTitleExtentF = 0.25
    lbres@lbTitleString = "~F25~Horizontal water vapor transport (g/m/s/Pa)";optional
    lbres@lbLabelStride = 1
    nboxes := dimsizes(colors)
    labels := "~F25~"+cnlevels
    lbid = gsn_create_labelbar(wks,nboxes,labels,lbres)
    draw(lbid)
    ;drawNDCGrid(wks)

;Create panel
    resP = True
    resP@gsnPanelLabelBar = False;Create label self
    resP@gsnPanelRowSpec = True
    resP@gsnPanelCenter = True
    resP@gsnPanelBottom = 0.12
    ;resP@gsnPanelYWhiteSpacePercent = 5
    ;drawNDCGrid(wks)
    gsn_panel(wks,plot,(/3/),resP)
end
