begin
    dq = str_get_dq()
    date_cmd   = "date +" + dq + "%a %b %d %H:%M:%S %Z %Y" + dq
    wcStrt = systemfunc(date_cmd)
;---Processing----------------
    data_path = "./data/"
    case_list = (/"cmorph", "u3km", "v4km_33N132E", "u60km"/)

    ;cmorph rainfall and geopotential height at 500hPa
    fi_rain_cmorph = addfile(data_path + case_list(0) + "/" + case_list(0) + "_total_rain_20200611-0709.nc", "r")
    nday = 30;
    rain_cmorph = fi_rain_cmorph->rain / nday
    rain_cmorph!0 = "lat"
    rain_cmorph!1 = "lon"
    rain_cmorph&lat = fi_rain_cmorph->lat
    rain_cmorph&lon = fi_rain_cmorph->lon

    fi_GPH_ERA5 = addfile(data_path + case_list(0) + "/" +  "height_500hPa.nc", "r")
    ;gravity = 9.80665
    height_500hPa = fi_GPH_ERA5->height_500hPa
    printVarSummary(height_500hPa)

    ;mpas case
    Re = get_sphere_radius()
    fi_rainnc_u3km = addfile(data_path + case_list(1) + "/" +  "rainnc_hr.nc", "r")
    fi_rainc_u3km  = addfile(data_path + case_list(1) + "/" +  "rainc_hr.nc", "r")
    rainnc_u3km = fi_rainnc_u3km->rainnc_hr
    rainc_u3km = fi_rainc_u3km->rainc_hr
    rain_u3km = (rainnc_u3km + rainc_u3km)*24

    ;fi_height_u3km = addfile(data_path + case_list(1) + "/" + "height_500hPa.nc","r")
    mpas_data = "/storage/aemolcore02/jungu/2020_Kyushu/"
    fi_height_u3km = addfile(mpas_data + case_list(1) +  "/ensemble/mpas_out/monthly_avg/sep_vars/isobaric/zgrid_isobaric.nc", "r")
    height_u3km = fi_height_u3km->zgrid(:,18)
    height_u3km_new = Re*height_u3km/(Re+height_u3km)

    fi_rainnc_v4km = addfile(data_path + case_list(2) + "/" +  "rainnc_hr.nc", "r")
    fi_rainc_v4km  = addfile(data_path + case_list(2) + "/" +  "rainc_hr.nc", "r")
    rainnc_v4km = fi_rainnc_v4km->rainnc_hr
    rainc_v4km = fi_rainc_v4km->rainc_hr
    rain_v4km = (rainnc_v4km + rainc_v4km)*24
    fi_height_v4km = addfile(data_path + case_list(2) + "/" + "height_500hPa.nc","r")
    height_v4km = fi_height_v4km->height_500hPa
    height_v4km_new = Re*height_v4km/(Re+height_v4km)

    fi_rainnc_u60km = addfile(data_path + case_list(3) + "/" +  "rainnc_hr.nc", "r")
    fi_rainc_u60km  = addfile(data_path + case_list(3) + "/" +  "rainc_hr.nc", "r")
    rainnc_u60km = fi_rainnc_u60km->rainnc_hr
    rainc_u60km = fi_rainc_u60km->rainc_hr
    rain_u60km = (rainnc_u60km + rainc_u60km)*24

    fi_height_u60km = addfile(mpas_data + case_list(3) +  "/ensemble/mpas_out/monthly_avg/sep_vars/isobaric/zgrid_isobaric.nc", "r")
    height_u60km = fi_height_u60km->zgrid(:,18)
    height_u60km_new = Re*height_u60km/(Re+height_u60km)

    mesh_path = "/storage/aemolcore02/jungu/mesh/"
    res_list  = (/"u3km","rotated_4-60km_33N132E_785410","u60km"/)

    mesh_u3km_fi = addfile(mesh_path + res_list(0) + "/cell_fill.nc","r")
    lat_u3km = mesh_u3km_fi->latCell
    lon_u3km = mesh_u3km_fi->lonCell
    ;latvoc_u3km = mesh_u3km_fi->latvoc
    ;lonvoc_u3km = mesh_u3km_fi->lonvoc

    mesh_v4km_fi = addfile(mesh_path + res_list(1) + "/cell_fill.nc","r")
    lat_v4km = mesh_v4km_fi->latCell
    lon_v4km = mesh_v4km_fi->lonCell
    ;latvoc_v4km = mesh_v4km_fi->latvoc
    ;lonvoc_v4km = mesh_v4km_fi->lonvoc

    mesh_u60km_fi = addfile(mesh_path + res_list(2) + "/cell_fill.nc","r")
    lat_u60km = mesh_u60km_fi->latCell
    lon_u60km = mesh_u60km_fi->lonCell
    ;latvoc_u60km = mesh_u60km_fi->latvoc
    ;lonvoc_u60km = mesh_u60km_fi->lonvoc

    ;select region
    minlat = 23.
    maxlat = 44.
    minlon = 122.
    maxlon = 154.
    wallClockElapseTime(wcStrt, "Processing", 0)
;-----------------------------
    wcStrtGraphics = systemfunc(date_cmd)
;---Graphics------------------
    wks_name = "Figure1_abcd"
    wks_type = "png"
    N_res = 2
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
    res@gsnStringFontHeightF = 0.019
    res@gsnLeftString = ""
    res@gsnRightString= ""
    res@gsnLeftStringOrthogonalPosF =  0.01
    res@gsnRightStringOrthogonalPosF = 0.02

    mpres = res
    mpres@mpFillOn          = True
    mpres@mpDataSetName     = "/storage/aemolcore02/jungu/Data/Earth..4/Earth..4"
    mpres@mpDataBaseVersion = "MediumRes"
    ;outline
    mpres@mpOutlineOn       = True
    mpres@mpOutlineBoundarySets = "Geophysical"
    mpres@mpGeophysicalLineThicknessF = 1*N_res
    ;projection and limit mode
    ;mpres@mpCenterLonF = 138
    mpres@mpMaxLatF = maxlat
    mpres@mpMinLatF = minlat
    mpres@mpMaxLonF = maxlon
    mpres@mpMinLonF = minlon
    ;mas tickmark
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
    mpres@tmXBLabelFont = 25
    mpres@tmXBMode = "Explicit"
    mpres@tmXBValues = ispan(120,150,10)
    mpres@tmXBLabels = "~F25~" + abs(mpres@tmXBValues) + "~S~o~N~E"
    mpres@tmYLMode = "Explicit"

    YLValues = ispan(25,45,5)
    nValues  = dimsizes(YLValues)
    YLLabels = new(nValues,string)
    do i = 0, nValues -1 
        if(YLValues(i) .lt. 0)then
            YLLabels(i) = YLValues(i) + "~S~o~N~S"
        else
            YLLabels(i) = YLValues(i) + "~S~o~N~N"
        end if
    end do

    mpres@tmYLValues = YLValues
    mpres@tmYLLabels = "~F25~" +  YLLabels

    cnlevels = (/0.5, 1, 2.5, 5., 7.5, 10., 12.5, 15., 17.5,20/)
    ;cnlevels = fspan(0.5,20,40)
    ;print(cnlevels)
    rain_cmap = read_colormap_file("WhiteBlueGreenYellowRed")
    ;colors = rain_cmap(0:240:6,:)
    ;colors = rain_cmap(17:237:22,:)
    colors = rain_cmap(0:240:24,:)

    cnres = mpres
    cnres@vpWidthF = 0.6
    cnres@vpHeightF= 0.6
    cnres@cnFillDrawOrder = "Draw"
    ;cnres@cnFillMode = "CellFill"
    cnres@cnFillMode = "RasterFill"
    ;cnres@cnRasterSmoothingOn = True
    cnres@cnInfoLabelOn   = False
    cnres@cnFillOn        = True
    cnres@cnLinesOn       = False
    cnres@cnLineLabelsOn  = False
    cnres@cnLevelSelectionMode = "ExplicitLevels"
    cnres@cnLevels        := cnlevels
    cnres@cnFillColors    := colors
    cnres@lbLabelBarOn    = False
    ;cnres@trGridType      = "TriangularMesh"
    ;height contour
    lnres = True; Important
    lnres@tiMainString = ""
    lnres@cnFillMode = "RasterFill"
    lnres@cnFillDrawOrder = "PostDraw"
    lnres@cnFillOn  = False
    lnres@cnLinesOn = True
    lnres@cnLevelSelectionMode = "ExplicitLevels"
    lnres@cnLevels = (/588/)*10
    ;lnres@cnMinLevelValF = 5760
    ;lnres@cnMaxLevelValF = 5940
    ;lnres@cnLevelSpacingF= 20.

    ;Set some resources for color contour lines
    lnres@cnMonoLineThickness   = False;Important
    thicknesses = (/4/)*2
    lnres@cnLineThicknesses     = thicknesses
    lnres@cnLineLabelFontHeightF=0.01
    ;lnres@cnLineDashSegLenF = 0.1
    lnres@cnLineLabelPlacementMode = "Computed"
    lnres@cnLineLabelDensityF =  1.5
    lnres@cnLineLabelInterval = 2
    lnres@cnInfoLabelOn = False
    lnres@cnMonoLineColor  = False;Important
    Colors = (/"dodgerblue4"/)
    lnres@cnLineColors     = Colors
    lnres@cnMonoLineDashPattern = True
    lnres@cnLineLabelFont = 25
    lnres@cnLineLabelsOn = False


    plot = new(4,graphic)
    cnres@gsnLeftString = "(a) CMORPH"
    cnres@gsnRightString = ""
    ;cnres@sfXArray = lon_u3km
    ;cnres@sfYArray = lat_u3km
    cnres@trGridType      = "TriangularMesh"
    ;cnres@sfXCellBounds = lonvoc_u3km
    ;cnres@sfYCellBounds = latvoc_u3km
    plot(0) = gsn_csm_contour_map_overlay(wks, rain_cmorph, height_500hPa, cnres, lnres)

    ;delete([/cnres@trGridType/])
    cnres@gsnLeftString = "(b) U60KM"
    cnres@gsnRightString = ""
    cnres@sfXArray = lon_u60km
    cnres@sfYArray = lat_u60km
    lnres@sfXArray = lon_u60km
    lnres@sfYArray = lat_u60km
    ;cnres@sfXCellBounds = lonvoc_u60km
    ;cnres@sfYCellBounds = latvoc_u60km
    lnres@cnLineDashPattern = 0
    plot(1) = gsn_csm_contour_map_overlay(wks, rain_u60km, height_u60km_new, cnres, lnres)
    ;lnres@cnLineDashPattern = 0
    ;anno_1 = gsn_csm_contour(wks, height_u60km_new, lnres)
    ;overlay(plot(1),anno_1)
    ;anno_2 = gsn_add_annotation(plot(1),anno_1,False)

    delete([/cnres@sfXArray, cnres@sfYArray/])
    delete([/lnres@sfXArray, lnres@sfYArray/])

    cnres@gsnLeftString = "(c) V4KM"
    cnres@gsnRightString = ""
    cnres@sfXArray = lon_v4km
    cnres@sfYArray = lat_v4km
    lnres@sfXArray = lon_v4km
    lnres@sfYArray = lat_v4km
    ;cnres@sfXCellBounds = lonvoc_v4km
    ;cnres@sfYCellBounds = latvoc_v4km
    lnres@cnLineDashPattern = 0
    plot(2) = gsn_csm_contour_map_overlay(wks, rain_v4km, height_v4km_new, cnres, lnres)
    ;lnres@cnLineDashPattern = 0
    ;anno_2 = gsn_csm_contour(wks, height_v4km_new, lnres)
    ;overlay(plot(2),anno_2)
    delete([/cnres@sfXArray, cnres@sfYArray/])
    delete([/lnres@sfXArray, lnres@sfYArray/])

    clres   = True
    clres@gsLineColor      = "orange"
    clres@gsLineThicknessF = 3*N_res
    clres@gsLineDashPattern    = 11

    circle    = geolocation_circle(33, 132, 14.8, 0, 180, False)
    circle_lat = circle[0]      ; For clarity: explicitly extract list elements
    circle_lon = circle[1]
    dum1 = gsn_add_polyline(wks, plot(2), circle_lon(0,0,:), circle_lat(0,0,:), clres)


    clres@gsLineColor      = "Orange"
    circle2    = geolocation_circle(33, 132, 34, 0, 180, False)
    circle2_lat = circle2[0]      ; For clarity: explicitly extract list elements
    circle2_lon = circle2[1]
    dum2 = gsn_add_polyline(wks, plot(2), circle2_lon(0,0,:), circle2_lat(0,0,:), clres)
    print("***draw circle***")


    cnres@gsnLeftString = "(d) U3KM"
    cnres@gsnRightString = ""
    lnres@sfXArray = lon_u3km
    lnres@sfYArray = lat_u3km
    cnres@sfXArray = lon_u3km
    cnres@sfYArray = lat_u3km
    ;cnres@sfXCellBounds = lonvoc_v4km
    ;cnres@sfYCellBounds = latvoc_v4km
    lnres@cnLineDashPattern = 0
    plot(3) = gsn_csm_contour_map_overlay(wks, rain_u3km, height_u3km_new, cnres, lnres)
    ;lnres@cnLineDashPattern = 0
    ;anno_3 = gsn_csm_contour(wks, height_u3km_new, lnres)
    ;overlay(plot(3),anno_3)

    ;---Attach the shapefile polylines using files read off gadm.org/country
    ;cn_shp_name = "/work/mingyue/World_shp/cnhimap.shp"
    ;wl_shp_name = "/work/mingyue/World_shp/world.shp"
    ;plres   = True
    ;plres@gsLineDashPattern = 0
    ;plres@gsLineThicknessF  = 2
    ;plres@gsLineColor = "gray"
    ;dum = new(4,graphic)
    ;do i = 0, 3
    ;    ;pro_id1 = gsn_add_shapefile_polylines(wks,plot,wl_shp_name,plres)
    ;    plres@gsLineColor       = "black"
    ;    plres@gsLineThicknessF  = 4
    ;    dum(i) = gsn_add_shapefile_polylines(wks,plot(i),cn_shp_name,plres)
    ;end do

    ;Create common label
    lbres = True
    lbres@vpXF = 0.1
    lbres@vpYF = 0.145
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
    lbres@lbLabelFontHeightF = 0.016
    lbres@lbLabelAlignment   = "InteriorEdges"
    lbres@lbTitlePosition = "Bottom"
    lbres@lbTitleFontHeightF = 0.019
    lbres@lbTitleOffsetF = 0.2
    lbres@lbTitleExtentF = 0.25
    lbres@lbTitleString = "~F25~Precipitation (mm/day)";optional
    lbres@lbLabelStride = 1
    nboxes := dimsizes(colors)
    labels := "~F25~"+cnlevels
    lbid = gsn_create_labelbar(wks,nboxes,labels,lbres)
    draw(lbid)

    resP = True
    resP@gsnPanelLabelBar = False
    resP@gsnPanelRowSpec = True
    resP@gsnPanelCenter = True
    resP@gsnPanelBottom = 0.12
    resP@gsnPanelYWhiteSpacePercent = 5
    ;drawNDCGrid(wks)
    gsn_panel(wks,plot,(/2,2/),resP)

    
;-----------------------------
    wallClockElapseTime(wcStrtGraphics, "Graphics", 0)
    wallClockElapseTime(wcStrt, "Processing and Graphics", 0)
end
