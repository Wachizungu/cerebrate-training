#!/bin/bash
#

slidedecks=("20200623-NATO-MUG-update")
mkdir output
export TEXINPUTS=::`pwd`/themes/
echo ${TEXINPUTS}
for slide in ${slidedecks[@]}; do
        cd ${slide}
        if test -f "slide_nl.tex"; then
                pdflatex slide_nl.tex
                pdflatex slide_nl.tex
        fi
        pdflatex slide.tex
        pdflatex slide.tex
        rm *.aux *.toc *.snm *.log *.out *.nav *.vrb
        cp slide.pdf ../output/${slide}.pdf
        rm slide.pdf
        if test -f "slide_nl.tex"; then
                cp slide_nl.pdf ../output/${slide}_nl.pdf
                rm slide_nl.pdf                
        fi        
        cd ..
done

echo "Generating ack page..."
cd complementary/ack
pdflatex ack.tex
rm *.aux *.log *.out
cp ack.pdf ../../output
rm ack.pdf
cd ../..

echo "Generating cheatsheet..."
cd training-support/compact-cheatsheet/
pdflatex cheatsheet.tex
rm *.aux *.toc *.snm *.log *.out *.nav *.vrb
cp cheatsheet.pdf ../../output
rm cheatsheet.pdf
cd ../..

echo "Generating checklist..."
cd training-support/checklist
pdflatex usage.tex
rm *.aux *.toc *.snm *.log *.out *.nav *.vrb
cp usage.pdf ../../output
rm usage.pdf
cd ../..

echo "Generating handout..."
cd output
for pdf in ${slidedecks[@]}; do
        listofpdf+="${pdf}.pdf "
done
echo ${listofpdf}

pdfunite ${listofpdf} cheatsheet.pdf usage.pdf ack.pdf ../misp-training.pdf
cd ..

exiftool -overwrite_original_in_place -Title="MISP Training and Slide Decks" -Author="CIRCL Computer Incident Response Center Luxembourg" -Subject="MISP Threat Intelligence Platform Training Materials" -Keywords="MISP Threat Intelligence CTI STIX information sharing yara sigma suricata snort bro openioc threat-actor TIP threat intelligence platform circl.lu training cybersecurity MISPProject" misp-training.pdf

rm table.md

echo "| Slides (PDF) | Source Code |">>table.md
echo "| ------------ | ----------- |">>table.md

for t in ${slidedecks[@]}; do
        echo "| [${t}](https://www.misp-project.org/misp-training/${t}.pdf) | [source](https://github.com/MISP/misp-training/tree/master/${t}) |" >>table.md
done

