# Fertilized-egg-detecting
Introduction
Artificial egg candling suffers the disadvantage to low efficiency and higher risk for misidentification. This project proposed a possible computational method to differentiate fertilized eggs and non-fertilized eggs based on the amount of red pigment of the image.

“Egg image” includes sample egg candling images we got from the internet.

Detail within mainV2_fromV1.m and mainV2_fromV1_piliang.m

Step 1 - Load the images in the folder

Step 2: Convert the image from RGB colour space to L*a*b* colour space

Step 3: Use the nearest neighbour rule to classify each pixel, each colour marker now has an 'a*' and a 'b*' value. Each pixel in the image is classified by calculating the Euclidean distance between that pixel and each colour marker. The minimum distance will tell you the best match for that pixel to that colour marker. For example, if the pixel has the smallest distance from a red marker, the pixel will be marked as a red pixel.

Step 4: Display the results of the nearest neighbour classification
The label matrix contains the colour labels for each pixel in the fabric image. Use the label matrix to separate the objects in the original fabric image by colour.

Step 5: Extract the second image, the layer containing the red area, and count the area of red to determine whether it is a red or white egg.



The demonstration video is available in the wmv file.
