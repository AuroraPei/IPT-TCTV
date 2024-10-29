# **TCTV: Infrared Small Target Detection via Joint Low Rankness and Local Smoothness Prior**  
Pei Liu, Jiangjun Peng, Hailin Wang, Danfeng Hong, Xiangyong Cao

<hr />

> **Abstract:** *Infrared small target detection is a challenging task in the computer vision field due to factors such as target scale variations and strong clutter. The existing infrared patch tensor (IPT) models achieve good detection performance but still have several limitations, such as inaccurate background modeling results and poor robustness against noise. To alleviate these issues, in this paper, we propose a new IPT model (dubbed as IPT-TCTV) by fully exploiting prior background knowledge. We construct an improved spatial-temporal (STT) model by sliding a 3-D window, which could better preserve the spatial correlation and temporal continuity of multiframe infrared images in the constructed tensor. Specifically, a joint low-rank and local smoothness regularization, i.e., tensor correlated total variation (TCTV), is utilized to characterize the background since the background exhibits not only the low-rank property but also the local smoothness property, without introducing additional trade-off parameters. Furthermore, considering the effect of edge structures, the \textit{l}$_{2,1}$ norm is adopted as a noise constraint to eliminate strong residuals, which can help to extract real targets from the background with more precision. Finally, we design an efficient alternating direction method of multipliers (ADMM) approach to solve the proposed model. Experimental results on some benchmark datasets illustrate that our IPT-TCTV model can achieve better detection performance than other state-of-the-art methods in various real scenes.*
<hr />

## Overall Framework
![3DSWSTT_model_00](https://github.com/user-attachments/assets/15f6a927-7bce-4c3b-a1f2-539a75004c80)

Overall framework of the proposed method. (a) The input infrared images. (b) The 3-D sliding window spatial-temporal tensor (3DSWSTT) model. \textit{Step1}: The input images are extended by padding the edges. \textit{Step2}: A series of stereo patch tensors are obtained by sliding a 3-D window from left to right and top to bottom. \textit{Step3}: The spatial-temporal patch tensor $\mathcal{O}$ is constructed by collecting the centered patch tensor and its 3 × 3 adjacent patch tensors as neighborhoods. (c) The TCTV model. The constructed patch tensor $\mathcal{O}$ is separated into three modules including the background $\mathcal{B}$, the target $\mathcal{T}$ and the noise $\mathcal{N}$ patch tensors by TCTV model and solved iteratively by ADMM approach, detailed in Algorithm 1. (d) The detected background and target images are produced by tensor reconstructions.

## Datasets
[_**ATR**_](http://www.sciencedb.cn/dataSet/handle/902)

The ATR dataset, which is also known as the ground/air background infrared detection and tracking dataset, was collected and released publicly by the ATR Key Laboratory of the National University of Defense Technology between 2017 and 2019. The ATR dataset contains 22 image sequences, 16177 frames, 16944 targets, and 30 trajectories. Furthermore, each image sequence corresponds to a label file in which each target is tagged with a label location in the associated image. All images are acquired by using medium-wave (3~5um) infrared imaging equipment in specifically designed experiments, and the resolution of each infrared image is 256×256 pixels.

[_**MSISTD**_](https://github.com/Crescent-Ao/MSISTD)

The MSISTD dataset, which was publicly released in 2022, is a multiscene and single-frame infrared small target dataset. It contains 1,077 images and 1,343 instances, which are 2.4 times and 2.5 times more than those contained in the largest existing real-world SIRST benchmarks, respectively. This dataset extends the scale of the original SIRST dataset from 427 to 1077 with high-quality annotations, which effectively solves the lack of quantity and diversity in infrared small target detection datasets.

