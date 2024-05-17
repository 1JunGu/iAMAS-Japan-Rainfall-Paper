begin
    dq = str_get_dq()
    date_cmd   = "date +" + dq + "%a %b %d %H:%M:%S %Z %Y" + dq
    wcStrt = systemfunc(date_cmd)
;---Processing----------------
    res_path = (/"u3km","v4-60km_33N132E_785410","u60km","u60km_100s"/)
    mpas_data = "/storage/aemolcore02/jungu/2020_Kyushu/"
    res_list = (/"u3km","v4-60km_33N132E","u60km_300s","u60km_100s"/)

    mesh_res = (/"u3km","rotated_4-60km_33N132E_785410","u60km","u60km"/)

    ;Ru3km_rainnc_fi = addfile(mpas_data+"/u3km/sep_vars/ensemble/monthly_avg/rainnc_hr.nc", "r")
    ;Ru3km_rainnc = (Ru3km_rainnc_fi->rainnc_hr)*24
    ;Ru3km_rainc_fi = addfile(mpas_data+"/u3km/sep_vars/ensemble/monthly_avg/rainc_hr.nc", "r")
    ;Ru3km_rainc = (Ru3km_rainc_fi->rainc_hr)*24
    ;Ru3km_rain = Ru3km_rainnc + Ru3km_rainc

    ;Rv4km_rainnc_fi = addfile(mpas_data+"/v4-60km_33N132E_785410/sep_vars/ensemble/monthly_avg/rainnc_hr.nc", "r")
    ;Rv4km_rainnc = (Rv4km_rainnc_fi->rainnc_hr)*24
    ;Rv4km_rainc_fi = addfile(mpas_data+"/v4-60km_33N132E_785410/sep_vars/ensemble/monthly_avg/rainc_hr.nc", "r")
    ;Rv4km_rainc = (Rv4km_rainc_fi->rainc_hr)*24
    ;Rv4km_rain = Rv4km_rainnc + Rv4km_rainc


    ;R300s_rainnc_fi = addfile(mpas_data+"/u60km/sep_vars/ensemble/monthly_avg/rainnc_hr.nc", "r")
    ;R300s_rainnc = (R300s_rainnc_fi->rainnc_hr)*24
    ;R300s_rainc_fi = addfile(mpas_data+"/u60km/sep_vars/ensemble/monthly_avg//rainc_hr.nc", "r")
    ;R300s_rainc = (R300s_rainc_fi->rainc_hr)*24
    ;R300s_rain = R300s_rainnc + R300s_rainc

    ;R100s_rainnc_fi = addfile(mpas_data+"/u60km_100s/sep_vars/ensemble/monthly_avg/rainnc_hr.nc", "r")
    ;R100s_rainnc = (R100s_rainnc_fi->rainnc_hr)*24
    ;R100s_rainc_fi = addfile(mpas_data+"/u60km_100s/sep_vars/ensemble/monthly_avg//rainc_hr.nc", "r")
    ;R100s_rainc = (R100s_rainc_fi->rainc_hr)*24
    ;R100s_rain = R100s_rainnc + R100s_rainc

    var = "rainnc_hr"
    ires = 0
    u3km_fi = addfile(mpas_data+res_path(ires) +  "/sep_vars/ensemble/monthly_avg/ERA5/" + var  +".nc", "r")
    u3km_nc = u3km_fi->$var$
    ires=1
    u60km_fi = addfile(mpas_data+res_path(ires) +  "/sep_vars/ensemble/monthly_avg/ERA5/" + var +".nc", "r")
    u60km_nc = u60km_fi->$var$

    var = "rainc_hr"
    ires = 0
    u3km_fi = addfile(mpas_data+res_path(ires) +  "/sep_vars/ensemble/monthly_avg/ERA5/" + var  +".nc", "r")
    u3km_c = u3km_fi->$var$
    ires=1
    u60km_fi = addfile(mpas_data+res_path(ires) +  "/sep_vars/ensemble/monthly_avg/ERA5/" + var +".nc", "r")
    u60km_c = u60km_fi->$var$


    u3km = u3km_nc + u3km_c
    printMinMax(u3km, 1)
    u60km = u60km_nc + u60km_c
    printMinMax(u60km, 1)
    mslp_diff = (u3km-u60km)*24
    copy_VarCoords(u3km_nc,mslp_diff)


    printMinMax(mslp_diff, 1)

    ;select region
    minlat = 0.
    ;minlat = 0.
    maxlat = 45.
    minlon = 100.
    maxlon = 160.
;-----------------------------
    wallClockElapseTime(wcStrt, "Processing", 0)
    wcStrtGraphics = systemfunc(date_cmd)
;---Graphics------------------
    wks_name = "Figure4b"
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
    res@gsnStringFontHeightF = 0.017
    res@gsnLeftString = "" + res_list(ires)
    res@gsnRightString= ""
    res@gsnLeftStringOrthogonalPosF = 0.01
    res@gsnRightStringOrthogonalPosF = 0.02

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
    mpres@tmXBLabelFontHeightF = 0.015
    mpres@tmYLLabelFontHeightF = 0.015

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

    ;cnlevels = (/0.1, 0.5, 2., 5., 7.5, 10., 12.5, 15., 17.5,20/)
    ;rain_cmap = read_colormap_file("WhiteBlueGreenYellowRed")
    ;colors = rain_cmap(17:237:22,:)

    ;cmap  = read_colormap_file("WhiteBlueGreenYellowRed")
    ;colors = new((/12,4/),"float")
    ;colors(0,:) = cmap(0,:)
    ;colors(1:11,:) = cmap(23:223:20,:)
    ;cnlevels = fspan(1000,1020,11)

    cmap = read_colormap_file("hotcolr_19lev")
    colors = new((/20,4/),double)
    colors  = cmap(:,:)
    cnlevels = fspan(-9,9,19)

    cnres = mpres
    cnres@vpWidthF = 0.8
    cnres@vpXF = 0.1
    ;cnres@vpHeightF= 0.6
    cnres@cnFillDrawOrder = "Draw"
    ;cnres@cnFillMode = "CellFill"
    cnres@cnFillMode = "RasterFill"
    cnres@cnRasterSmoothingOn = True
    cnres@cnInfoLabelOn   = False
    cnres@cnFillOn        = True
    cnres@cnLinesOn       = False
    cnres@cnLineLabelsOn  = False
    cnres@cnLevelSelectionMode = "ExplicitLevels"
    cnres@cnLevels        := cnlevels
    cnres@cnFillColors    := colors
    cnres@lbLabelBarOn    = False
    ;cnres@trGridType      = "TriangularMesh"
    ;cnres@gsnLeftString = "(a) " +str_upper(res_list(ires))
    cnres@gsnLeftString = "(b)"
    ;cnres@sfXArray = lon
    ;cnres@sfYArray = lat
    ;cnres@sfXCellBounds = lonvoc_u3km
    ;cnres@sfYCellBounds = latvoc_u3km
    plot = gsn_csm_contour_map(wks, mslp_diff, cnres)

    draw(plot)
    
    ;Create common label
    lbres = True
    lbres@vpXF = 0.2
    lbres@vpYF = 0.18
    ;lbres@vpYF = 0.30
    lbres@vpWidthF = 0.6
    lbres@vpHeightF= 0.06
    lbres@lbPerimOn = False
    lbres@lbBoxLinesOn = False
    lbres@lbBoxSeparatorLinesOn = False
    lbres@lbBoxLineThicknessF = 1.2*N_res
    lbres@lbFillColors  := colors
    lbres@lbOrientation = "horizontal"
    lbres@lbMonoFillPattern = True
    lbres@lbLabelFontHeightF = 0.013
    lbres@lbLabelAlignment   = "InteriorEdges"
    lbres@lbTitlePosition = "Bottom"
    lbres@lbTitleFontHeightF = 0.016
    lbres@lbTitleOffsetF = 0.2
    lbres@lbTitleExtentF = 0.25
    lbres@lbTitleString = "~F25~Precipitation differences (mm/day)";optional
    lbres@lbLabelStride = 1
    nboxes := dimsizes(colors)
    labels := "~F25~"+cnlevels
    lbid = gsn_create_labelbar(wks,nboxes,labels,lbres)
    draw(lbid)

    ;drawNDCGrid(wks)
    frame(wks)
    
;-----------------------------
    wallClockElapseTime(wcStrtGraphics, "Graphics", 0)
    wallClockElapseTime(wcStrt, "Processing and Graphics", 0)
end
