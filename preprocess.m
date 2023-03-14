clc; clear; close all; warning off all;

% -> training data sel darah merah normal <- %

directory = 'dataset-eritrosit\data-train\normal';
filename = dir(fullfile(directory, '*.jpg'));
totaldata = numel(filename);

% inisialisasi ciri bentuk dan target bentuk

normalcharacter = zeros(totaldata, 4);
normaltarget = cell(totaldata, 1);

% proses pengolahan citra sel darah merah normal

for datapic = 1 : totaldata
    % input dan output citra asli
    originalpic = im2double(imread(fullfile(directory, filename(datapic).name)));
    % figure, imshow(originalpic);
    
    % konversi warna citra asli menjadi citra green
    greenpic = originalpic(:,:,2);
    % figure, imshow(greenpic);
    % figure, imhist(greenpic);

    % peningkatan kontras citra green
    minvalue = min(min(greenpic)); maxvalue = max(max(greenpic));
    upcontrast = imadjust(greenpic, [minvalue/1 maxvalue/1], [0/1 1/1]);
    % figure, imshow(upcontrast);

    % membersihkan noise pada citra hasil contrast
    noisepic = imnoise(upcontrast, 'salt & pepper', 0.02);
    clearpic = medfilt2(noisepic, [5 5]);
    % figure, imshow(clearpic);

    % segmentasi menggunakan metode otsu thresholding
    otsuthresh = graythresh(clearpic);
    otsupic = im2bw(clearpic, otsuthresh);
    % figure, imshow(otsupic);

    % invers citra (membalik warna citra hasil thresholding)
    inverpic = imcomplement(otsupic);
    % figure, imshow(inverpic);

    % melakukan operasi morfologi (penyempurnaan hasil segmentasi)
    % -> filling holes (menutup lubang pada objek)

    fillholes = imfill(inverpic, 'holes');
    % figure, imshow(fillholes);
    
    % -> area opening (membersihkan area di sekitar objek dari noise)

    fillarea = bwareaopen(fillholes, 2200);
    % figure, imshow(fillarea);

    erospic = imerode(fillarea, strel('disk', 5));
    % figure, imshow(erospic);

    % memulai ekstraksi fitur morfologi
    
    % pelabelan menggunakan 8 ketetanggaan
    AA = bwlabeln(erospic, 8);
    
    % jumlah label
    a = max(max(AA));

    for c = 1 : a
        area = 0;
        perimeter = 0;
        for i = 1 : 137
            for j = 1 : 137
                if AA(i,j) == c
                    area = area + 1;
                end
            end
        end
        for i = 2 : 136
            for j = 2 : 136
                if AA(i,j) == c
                    if AA(i,j) ~= AA(i-1,j) || AA(i,j) ~= AA(i+1,j) || AA(i,j) ~= AA(i,j-1) || AA(i,j) ~= AA(i,j+1)
                        perimeter = perimeter + 1;
                    end
                end
            end
        end
        luas(c) = area;
        keliling(c) = perimeter;
    end
    
    hitung = 0;
    for c = 1 : a
        if luas(c) >= 100
            hitung = hitung + 1;
            luas_area(hitung) = luas(c);
            keliling_area(hitung) = keliling(c);
        end
    end
    
    jum_luas = 0;
    jum_keliling = 0;
    for i = 1 : hitung
        jum_luas = jum_luas + luas_area(i);
        jum_keliling = jum_keliling + keliling_area(i);
    end
    
    bloodarea = jum_luas;
    perimeter = jum_keliling;
    compactness = perimeter^2 / bloodarea;
    circularity = 4 * pi * bloodarea / perimeter^2;

    % mengambil nilai ekstraksi fitur bentuk

    normalcharacter(datapic, 1) = bloodarea;
    normalcharacter(datapic, 2) = perimeter;
    normalcharacter(datapic, 3) = compactness;
    normalcharacter(datapic, 4) = circularity;

    % target normal

    normaltarget{datapic} = 'eritrosit normal';
end

% -> training data sel darah merah ellyptocytes <- %

directory = 'dataset-eritrosit\data-train\ellyptocytes';
filename = dir(fullfile(directory, '*.jpg'));
totaldata = numel(filename);

% inisialisasi ciri bentuk dan target bentuk

ellypcharacter = zeros(totaldata, 4);
ellyptarget = cell(totaldata, 1);

% proses pengolahan citra sel darah merah normal

for datapic = 1 : totaldata
    % input dan output citra asli
    originalpic = im2double(imread(fullfile(directory, filename(datapic).name)));
    % figure, imshow(originalpic);
    
    % konversi warna citra asli menjadi citra green
    greenpic = originalpic(:,:,2);
    % figure, imshow(greenpic);
    % figure, imhist(greenpic);

    % peningkatan kontras citra green
    minvalue = min(min(greenpic)); maxvalue = max(max(greenpic));
    upcontrast = imadjust(greenpic, [minvalue/1 maxvalue/1], [0/1 1/1]);
    % figure, imshow(upcontrast);

    % membersihkan noise pada citra hasil contrast
    noisepic = imnoise(upcontrast, 'salt & pepper', 0.02);
    clearpic = medfilt2(noisepic, [5 5]);
    % figure, imshow(clearpic);

    % segmentasi menggunakan metode otsu thresholding
    otsuthresh = graythresh(clearpic);
    otsupic = im2bw(clearpic, otsuthresh);
    % figure, imshow(otsupic);

    % invers citra (membalik warna citra hasil thresholding)
    inverpic = imcomplement(otsupic);
    % figure, imshow(inverpic);

    % melakukan operasi morfologi (penyempurnaan hasil segmentasi)
    % -> filling holes (menutup lubang pada objek)

    fillholes = imfill(inverpic, 'holes');
    % figure, imshow(fillholes);
    
    % -> area opening (membersihkan area di sekitar objek dari noise)

    fillarea = bwareaopen(fillholes, 2200);
    % figure, imshow(fillarea);

    erospic = imerode(fillarea, strel('disk', 5));
    % figure, imshow(erospic);

    % memulai ekstraksi fitur morfologi
    
    % pelabelan menggunakan 8 ketetanggaan
    AA = bwlabeln(erospic, 8);
    
    % jumlah label
    a = max(max(AA));

    for c = 1 : a
        area = 0;
        perimeter = 0;
        for i = 1 : 137
            for j = 1 : 137
                if AA(i,j) == c
                    area = area + 1;
                end
            end
        end
        for i = 2 : 136
            for j = 2 : 136
                if AA(i,j) == c
                    if AA(i,j) ~= AA(i-1,j) || AA(i,j) ~= AA(i+1,j) || AA(i,j) ~= AA(i,j-1) || AA(i,j) ~= AA(i,j+1)
                        perimeter = perimeter + 1;
                    end
                end
            end
        end
        luas(c) = area;
        keliling(c) = perimeter;
    end
    
    hitung = 0;
    for c = 1 : a
        if luas(c) >= 100
            hitung = hitung + 1;
            luas_area(hitung) = luas(c);
            keliling_area(hitung) = keliling(c);
        end
    end
    
    jum_luas = 0;
    jum_keliling = 0;
    for i = 1 : hitung
        jum_luas = jum_luas + luas_area(i);
        jum_keliling = jum_keliling + keliling_area(i);
    end
    
    bloodarea = jum_luas;
    perimeter = jum_keliling;
    compactness = perimeter^2 / bloodarea;
    circularity = 4 * pi * bloodarea / perimeter^2;

    % mengambil nilai ekstraksi fitur bentuk

    ellypcharacter(datapic, 1) = bloodarea;
    ellypcharacter(datapic, 2) = perimeter;
    ellypcharacter(datapic, 3) = compactness;
    ellypcharacter(datapic, 4) = circularity;

    % target normal

    ellyptarget{datapic} = 'eritrosit ellyptocytes';
end

% -> training data sel darah merah ovalocytes <- %

directory = 'dataset-eritrosit\data-train\ovalocytes';
filename = dir(fullfile(directory, '*.jpg'));
totaldata = numel(filename);

% inisialisasi ciri bentuk dan target bentuk

ovalcharacter = zeros(totaldata, 4);
ovalptarget = cell(totaldata, 1);

% proses pengolahan citra sel darah merah normal

for datapic = 1 : totaldata
    % input dan output citra asli
    originalpic = im2double(imread(fullfile(directory, filename(datapic).name)));
    % figure, imshow(originalpic);
    
    % konversi warna citra asli menjadi citra green
    greenpic = originalpic(:,:,2);
    % figure, imshow(greenpic);
    % figure, imhist(greenpic);

    % peningkatan kontras citra green
    minvalue = min(min(greenpic)); maxvalue = max(max(greenpic));
    upcontrast = imadjust(greenpic, [minvalue/1 maxvalue/1], [0/1 1/1]);
    % figure, imshow(upcontrast);

    % membersihkan noise pada citra hasil contrast
    noisepic = imnoise(upcontrast, 'salt & pepper', 0.02);
    clearpic = medfilt2(noisepic, [5 5]);
    % figure, imshow(clearpic);

    % segmentasi menggunakan metode otsu thresholding
    otsuthresh = graythresh(clearpic);
    otsupic = im2bw(clearpic, otsuthresh);
    % figure, imshow(otsupic);

    % invers citra (membalik warna citra hasil thresholding)
    inverpic = imcomplement(otsupic);
    % figure, imshow(inverpic);

    % melakukan operasi morfologi (penyempurnaan hasil segmentasi)
    % -> filling holes (menutup lubang pada objek)

    fillholes = imfill(inverpic, 'holes');
    % figure, imshow(fillholes);
    
    % -> area opening (membersihkan area di sekitar objek dari noise)

    fillarea = bwareaopen(fillholes, 2200);
    % figure, imshow(fillarea);

    erospic = imerode(fillarea, strel('disk', 5));
    % figure, imshow(erospic);

    % memulai ekstraksi fitur morfologi
    
    % pelabelan menggunakan 8 ketetanggaan
    AA = bwlabeln(erospic, 8);
    
    % jumlah label
    a = max(max(AA));

    for c = 1 : a
        area = 0;
        perimeter = 0;
        for i = 1 : 137
            for j = 1 : 137
                if AA(i,j) == c
                    area = area + 1;
                end
            end
        end
        for i = 2 : 136
            for j = 2 : 136
                if AA(i,j) == c
                    if AA(i,j) ~= AA(i-1,j) || AA(i,j) ~= AA(i+1,j) || AA(i,j) ~= AA(i,j-1) || AA(i,j) ~= AA(i,j+1)
                        perimeter = perimeter + 1;
                    end
                end
            end
        end
        luas(c) = area;
        keliling(c) = perimeter;
    end
    
    hitung = 0;
    for c = 1 : a
        if luas(c) >= 100
            hitung = hitung + 1;
            luas_area(hitung) = luas(c);
            keliling_area(hitung) = keliling(c);
        end
    end
    
    jum_luas = 0;
    jum_keliling = 0;
    for i = 1 : hitung
        jum_luas = jum_luas + luas_area(i);
        jum_keliling = jum_keliling + keliling_area(i);
    end
    
    bloodarea = jum_luas;
    perimeter = jum_keliling;
    compactness = perimeter^2 / bloodarea;
    circularity = 4 * pi * bloodarea / perimeter^2;

    % mengambil nilai ekstraksi fitur bentuk

    ovalcharacter(datapic, 1) = bloodarea;
    ovalcharacter(datapic, 2) = perimeter;
    ovalcharacter(datapic, 3) = compactness;
    ovalcharacter(datapic, 4) = circularity;

    % target normal

    ovalptarget{datapic} = 'eritrosit ovalocytes';
end

% mengambil nilai karakteristik dan target data training

traincharacter = [normalcharacter; ellypcharacter; ovalcharacter];
traintarget = [normaltarget; ellyptarget; ovalptarget];

% melakukan pelatihan menggunakan algoritma K-NN
    
bloodmodel = fitcknn(traincharacter, traintarget, 'NumNeighbors', 5);

% membaca kelas keluaran hasil pelatihan

trainresult = predict(bloodmodel, traincharacter);

% menghitung akurasi pelatihan

traindata = totaldata * 3;
traindata
trueresult = 0;
lossresult = totaldata * 3;
totaldata = size(traincharacter, 1);
for data = 1 : totaldata
    if isequal(trainresult{data}, traintarget{data})
        trueresult = trueresult + 1;
    end
end
lossresult = lossresult - trueresult;
trainaccuracy = trueresult / totaldata * 100;
trueresult, lossresult, trainaccuracy

% menyimpan nilai hasil training

save bloodmodel bloodmodel