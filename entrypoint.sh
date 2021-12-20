#!/bin/bash
npm install -g minify
npm install css-minify -g
npm install uglify-js -g
apt-get update
apt-get -y install moreutils

css-minify_file(){
    input=$1
    output=$2;
    filename="${input#*/}"
    echo "Minify file ${input} into ${output}/${filename} directory"
    mkdir -p $output/$(dirname $filename)

    output_path="${output}/${filename}"
    css-minify -f ${input} -o $(dirname ${output_path})
    extension=${output_path##*.}
    filebase=${output_path%.*}
    mv "${filebase}.min.${extension}" "${filebase}.${extension}"
    echo "CSS-minified ${input} > ${output_path}"
}

minify_file(){
    input=$1
    output=$2;
    filename="${input#*/}"
    echo "Minify file ${input} into ${output}/${filename} directory"
    mkdir -p $output/$(dirname $filename)

    output_path="${output}/${filename}"
    minify ${input} > ${output_path}
    echo "Minified ${input} > ${output_path}"
}

uglify_file(){
    input=$1
    output=$2;
    filename="${input#*/}"
    echo "Minify file ${input} into ${output}/${filename} directory"
    mkdir -p $output/$(dirname $filename)

    output_path="${output}/${filename}"
    uglifyjs ${input} --output ${output_path}
    echo "Uglified ${input} > ${output_path}"
}

list_files(){
    INPUT_DIRECTORY=$1
    OUTPUT_DIRECTORY=$2
    cp -r "${INPUT_DIRECTORY}/" $OUTPUT_DIRECTORY
    echo "List files from ${INPUT_DIRECTORY}"

    find $INPUT_DIRECTORY -type f \( -iname \*.html \) | while read fname
        do
            if [[ "$fname" != *"min."* ]]; then
                minify_file $fname $OUTPUT_DIRECTORY
            fi
        done

    find $INPUT_DIRECTORY -type f \( -iname \*.css \) | while read fname
        do
            if [[ "$fname" != *"min."* ]]; then
                css-minify_file $fname $OUTPUT_DIRECTORY
            fi
        done

    find $INPUT_DIRECTORY -type f \( -iname \*.js \) | while read fname
        do
            if [[ "$fname" != *"min."* ]]; then
                uglify_file $fname $OUTPUT_DIRECTORY
            fi
        done
}

INPUT_DIRECTORY=$1
OUTPUT_DIRECTORY=$2

if [ -z "$INPUT_DIRECTORY" ]
then
    INPUT_DIRECTORY="src"
fi

if [ -z "$INPUT_DIRECTORY" ]
then
    OUTPUT_DIRECTORY="dist"
fi


list_files $INPUT_DIRECTORY $OUTPUT_DIRECTORY
