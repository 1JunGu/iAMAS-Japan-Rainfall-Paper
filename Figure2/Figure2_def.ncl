begin
    ;plot single 2D variable
    ;panel: uniform 3km variable 4km uniform 60km
    cpu_start_time = get_cpu_time()
    ;start_time     = toint(systemfunc("date +%s"))

    var_prefix = "./"
    res_list = (/"u3km","v4-60km_33N132E_785410","u60km"/)
    setfileoption("nc","Format","NetCDF4")

    minlat = 0.
    maxlat = 45.
    minlon = 100.
    maxlon = 160.

    threshold = 250;IVT

    f_u3km = addfile(var_prefix + res_list(0) + "_moisture_flux.nc", "r")
    MFC_u3km = f_u3km->ivt
    ;MFC_u3km = MFC_u3km*1e4
    IUQ_u3km  = f_u3km->iuq
    IVQ_u3km  = f_u3km->ivq

    f_v4km = addfile(var_prefix + res_list(1) + "_moisture_flux.nc", "r")
    MFC_v4km = f_v4km->ivt
    ;MFC_v4km = MFC_v4km*1e4
    IUQ_v4km  = f_v4km->iuq
    IVQ_v4km  = f_v4km->ivq

;u60km
    f_u60km = addfile(var_prefix + res_list(2) + "_moisture_flux.nc", "r")
    MFC_u60km = f_u60km->ivt
    ;MFC_u60km = MFC_u60km*1e4
    IUQ_u60km  = f_u60km->iuq
    IVQ_u60km  = f_u60km->ivq

    ;printMinMax(var_u3km, 0)
    ;printMinMax(var_v4km, 0)
    ;printMinMax(var_u60km, 0)

;*********plot*********
    N_res = 4
    plot_name = "Figure2_def"

    wks_type = "png"
    wks_type@wkWidth  = 1024*N_res;2048
    wks_type@wkHeight = 1024*N_res
    ;wks_type@wkPDFResolution = 6000
    wks = gsn_open_wks(wks_type,plot_name)

    ;mfc_color = new((/13,4/),"float")
    ;mfc_cmap  = read_colormap_file("MPL_BrBG")
    ;trans_color = mfc_cmap(64,:)
    ;trans_color(3) = 0

    ;mfc_color(0:5,:) = mfc_cmap(0:50:10,:)
    ;mfc_color(6,:) = trans_color
    ;mfc_color(7:12,:) = mfc_cmap(77:127:10,:)
    ;mfc_cnlevels = (/-2.5,-2,-1.5,-1,-0.5,-0.2,0.2,0.5,1,1.5,2,2.5/)/5

    mfc_color = new((/11,4/),"float")
    mfc_cmap  = read_colormap_file("WhiteBlueGreenYellowRed")
    mfc_color(0,:) = mfc_cmap(0,:)
    mfc_color(1:10,:) = mfc_cmap(58:238:20,:);10 colors;space: 20
    mfc_cnlevels = (/250,275,300,350,400,450,500,550,600,700/);10


;set uniform resources
    res = True
    res@gsnDraw = False
    res@gsnFrame= False
    res@gsnAddCyclic = False
    res@gsnMaximize  = False
    res@gsnLeftString = ""
    res@gsnStringFont = 25
    res@gsnLeftStringOrthogonalPosF = 0.0
    res@gsnRightString= ""
    ;res@vpHeightF = 0.2
    res@vpWidthF  = 0.6

    mpres = res
    mpres@mpFillOn          = True
    mpres@mpDataSetName     = "/storage/aemolcore02/jungu/Data/Earth..4/Earth..4"
    mpres@mpDataBaseVersion = "LowRes"

    mpres@mpOutlineOn       = True
    mpres@mpOutlineBoundarySets = "Geophysical"
    mpres@mpGeophysicalLineThicknessF = 1*N_res
    ;mpres@mpOutlineSpecifiers   = (/"Canada"/)
    ;mpres@mpNationalLineDashPattern = 3
    ;mpres@mpNationalLineThicknessF  = 3.8
    ;mpres@mpUSStateLineThicknessF = 17.3
    mpres@mpMinLatF = minlat
    mpres@mpMaxLatF = maxlat
    mpres@mpMinLonF = minlon
    mpres@mpMaxLonF = maxlon

    mpres@tmXTOn = False
    mpres@tmYROn = False
    mpres@tmBorderThicknessF = 2*N_res
    mpres@tmYLMajorThicknessF = 2*N_res
    mpres@tmYLMajorLengthF    = 0.006
    mpres@tmXBMajorThicknessF = 2*N_res
    mpres@tmXBMajorLengthF    = 0.006

    mpres@tmXBMinorOn = False
    mpres@tmYLMinorOn = False
    mpres@tmXBLabelDeltaF = -0.5
    mpres@tmYLLabelDeltaF = -0.5
    mpres@tmXBLabelFontHeightF = 0.019
    mpres@tmYLLabelFontHeightF = 0.019

    mpres@tmXBMode = "Explicit"
    mpres@tmXBValues = ispan(toint(minlon), toint(maxlon), 20)
    ;mpres@tmXBValues = ispan(-120, 180, 60)
    mpres@tmXBLabels = "~F25~" + abs(mpres@tmXBValues) + "~S~o~N~E"


    mpres@tmYLMode = "Explicit"
    mpres@tmYLValues = ispan(-20,80,20)
    YLLabels = new(6,string)
    YLLabels1 = "~F25~" + (/20/)+ "~S~o~N~S"
    YLLabels2 = "~F25~0~S~o~N~"
    YLLabels3 = "~F25~" + (/20,40,60,80/)+ "~S~o~N~N"
    YLLabels(0) = YLLabels1
    YLLabels(1) = YLLabels2
    YLLabels(2:5) = YLLabels3
    mpres@tmYLLabels = YLLabels

    mpres@mpGridAndLimbOn = True
    mpres@mpGridLatSpacingF = 10.0
    mpres@mpGridLonSpacingF = 10.0
    mpres@mpGridLineDashPattern =16
    mpres@mpGridLineThicknessF = 1.0*N_res

    ;;terrian_plot = gsn_csm_contour_map(wks,terrian,mpres)

    cnres = mpres
    cnres@cnFillDrawOrder = "Draw"
    cnres@cnInfoLabelOn   = False
    cnres@cnFillOn        = True
    cnres@cnLinesOn       = False
    cnres@cnLineLabelsOn  = False
    cnres@cnLevelSelectionMode = "ExplicitLevels"
    cnres@cnLevels        = mfc_cnlevels
    cnres@cnFillColors    = mfc_color
    cnres@cnFillMode      = "RasterFill"
    ;cnres@cnSmoothingOn   = True
    cnres@cnRasterSmoothingOn = True
    ;cnres@cnSmoothingDistanceF= 0.01
    ;cnres@cnSmoothingTensionF = 0.01

    cnres@lbLabelBarOn    = False
    ;cnres@pmLabelBarHeightF = 0.06
    ;cnres@pmLabelBarWidthF  = 0.55
    ;cnres@lbLabelFontHeightF = 0.015
    ;cnres@lbTitleString = "Precipitation [mm/h]";optional
    ;cnres@pmLabelBarOrthogonalPosF = 0.08
    ;cnres@lbTitlePosition = "Bottom"
    ;cnres@lbTitleFontHeightF = 0.015
    vcres                       = res 
    vcres@vcGlyphStyle          = "LineArrow"
    vcres@vcRefLengthF          = 0.03
    vcres@vcLineArrowColor      = "Black"
    vcres@vcFillArrowFillColor  = "Black"
    vcres@vcLineArrowThicknessF = 1.5*N_res
    vcres@vcFillArrowEdgeThicknessF = 3*N_res
    vcres@vcFillArrowEdgeColor  = "Black"
    vcres@vcMinDistanceF        = 0.025
    vcres@vcVectorDrawOrder     = "PostDraw"
    vcres@vcMinMagnitudeF       = 100.

    vcres@vcRefAnnoOn               = True
    vcres@vcRefMagnitudeF           = 250.0
    vcres@vcRefAnnoString1          = "250"
    vcres@vcRefAnnoString2          = "[kg/m/s]"
    vcres@vcRefAnnoPerimOn          = True
    vcres@vcRefAnnoJust             = "TopLeft"
    vcres@vcRefAnnoSide             = "Top"
    vcres@vcRefAnnoOrthogonalPosF   = -1.5
    vcres@vcRefAnnoParallelPosF     = 0
    vcres@vcRefAnnoBackgroundColor  = "white"
    vcres@vcRefAnnoFont = 25
    vcres@vcRefAnnoFontHeightF = 0.019

    plot  =  new(3,graphic)
    vector  =  new(3,graphic)
    ;f_static = addfile(u3km_static_name,"r")
    ;terrian = f_static->ter
    ;latCell = (f_static->latCell)*RAD2DEG
    ;lonCell = (f_static->lonCell)*RAD2DEG

    ;f_pw   = addfile(u3km_pw_average,"r")
    ;pw = f_pw->pw
    ;pw_3km = 1.0e-3*where(pw_3km  .le. 1., pw_3km@_FillValue, pw_3km)
    ;pw_4km = 1.0e-3*where(pw_4km  .le. 1., pw_4km@_FillValue, pw_4km)
    ;pw_60km =1.0e-3*where(pw_60km .le. 1., pw_60km@_FillValue, pw_60km)

    ;cnres@cnFillMode = "CellFill"
    ;cnres@sfXArray = lonCell_u3km
    ;cnres@sfYArray = latCell_u3km
    ;cnres@cnRasterSmoothingOn = True
    ;;cnres@sfXCellBounds = lonvoc_u3km
    ;;cnres@sfYCellBounds = latvoc_u3km
    ;cnres@gsnLeftString = "U3KM"
    ;;mpres@tmYLOn       = True
    ;;mpres@tmYLLabelsOn = True
    ;cnres@gsnRightString = timestamp
    ;cnres@gsnRightStringOrthogonalPosF = -0.00
    ;;plot(0) = gsn_csm_map(wks,cnres)
    ;plot(0) = gsn_csm_contour_map(wks,var_u3km,cnres)
    ;delete([/cnres@sfXArray,cnres@sfYArray,cnres@sfXCellBounds,cnres@sfYCellBounds/])

    cnres@gsnLeftString = "(d) U3KM"
    cnres@gsnRightString = ""
    ;cnres@gsnRightStringOrthogonalPosF = 0.01
    plot(0) = gsn_csm_contour_map(wks,MFC_u3km,cnres)
    vector(0) = gsn_csm_vector(wks,IUQ_u3km,IVQ_u3km,vcres)
    overlay(plot(0),vector(0))

    cnres@gsnLeftString = "(e) V4KM"
    cnres@gsnRightString = ""
    vcres@vcRefAnnoOn = False
    ;cnres@gsnRightStringOrthogonalPosF = 0.01
    plot(1) = gsn_csm_contour_map(wks,MFC_v4km,cnres)
    vector(1) = gsn_csm_vector(wks,IUQ_v4km,IVQ_v4km,vcres)
    overlay(plot(1),vector(1))


    cnres@gsnLeftString = "(f) U60KM"
    cnres@gsnRightString = " "
    plot(2) = gsn_csm_contour_map(wks,MFC_u60km,cnres)
    vector(2) = gsn_csm_vector(wks,IUQ_u60km,IVQ_u60km,vcres)
    overlay(plot(2),vector(2))
    ;delete([/cnres@sfXArray,cnres@sfYArray/])

    clres   = True
    clres@gsLineColor      = "NavyBlue"
    clres@gsLineThicknessF = 3*N_res
    clres@gsLineDashPattern    = 11

    circle    = geolocation_circle(33, 132, 14.8, 0, 180, False)
    circle_lat = circle[0]      ; For clarity: explicitly extract list elements
    circle_lon = circle[1]
    dum1 = gsn_add_polyline(wks, plot(1), circle_lon(0,0,:), circle_lat(0,0,:), clres)


    clres@gsLineColor      = "Orange"
    circle2    = geolocation_circle(33, 132, 34, 0, 180, False)
    circle2_lat = circle2[0]      ; For clarity: explicitly extract list elements
    circle2_lon = circle2[1]
    dum2 = gsn_add_polyline(wks, plot(1), circle2_lon(0,0,:), circle2_lat(0,0,:), clres)
    print("***draw circle***")

    lnres = True
    lnres@gsLineColor = "Red"
    lnres@gsLineThicknessF = 4.5*N_res
    lnres@gsLineDashPattern = 0
    ln_lat = (/25,40/)
    ln_lon = (/132,132/)

    txres = True
    txres@txFontColor = "Red"
    txres@txFont = 25
    txres@txFontHeightF = 0.018
    ln_lat = (/25,40/)
    ln_lon = (/132,132/)

    dum3 = gsn_add_polyline(wks,plot(0),ln_lon,ln_lat,lnres)
    dum4 = gsn_add_polyline(wks,plot(1),ln_lon,ln_lat,lnres)
    dum5 = gsn_add_polyline(wks,plot(2),ln_lon,ln_lat,lnres)

    dum61 = gsn_add_text(wks,plot(0),"A",133,23,txres)
    dum62 = gsn_add_text(wks,plot(0),"A'",133,42,txres)
    dum71 = gsn_add_text(wks,plot(1),"A",133,23,txres)
    dum72 = gsn_add_text(wks,plot(1),"A'",133,42,txres)
    dum81 = gsn_add_text(wks,plot(2),"A",133,23,txres)
    dum82 = gsn_add_text(wks,plot(2),"A'",133,42,txres)

;Create common label
    lbres = True
    lbres@vpXF = 0.1
    lbres@vpYF = 0.45
    lbres@vpWidthF = 0.8
    lbres@vpHeightF= 0.07

    lbres@lbPerimOn = False
    lbres@lbBoxLinesOn = False
    lbres@lbBoxSeparatorLinesOn = False
    lbres@lbBoxLineThicknessF = 1.2*N_res
    lbres@lbOrientation = "Horizontal"
    lbres@lbFillColors  = mfc_color
    lbres@lbMonoFillPattern = True
    lbres@lbLabelFontHeightF = 0.014
    lbres@lbLabelAlignment   = "InteriorEdges"
    lbres@lbTitleJust = "TopCenter"
    lbres@lbTitleFontHeightF = 0.015
    lbres@lbTitleOffsetF = 0.2
    lbres@lbTitleExtentF = 0.25
    lbres@lbTitleString = "~F25~Integrated water vapor transport (kg/m/s)";optional
    lbres@lbTitlePosition = "Bottom"
    lbres@lbLabelStride = 1
    nboxes = dimsizes(mfc_color)
    labels = "~F25~"+mfc_cnlevels
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

    print(get_script_prefix_name() + ": cpu time =  " + (cpu_end_time - cpu_start_time) + " seconds.")
end
