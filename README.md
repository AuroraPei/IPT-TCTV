# **TCTV: Infrared Small Target Detection via Joint Low Rankness and Local Smoothness Prior**  
Pei Liu, Jiangjun Peng, Hailin Wang, Danfeng Hong, Xiangyong Cao

<hr />

> **Abstract:** *Infrared small target detection is a challenging task in the computer vision field due to factors such as target scale variations and strong clutter. The existing infrared patch tensor (IPT) models achieve good detection performance but still have several limitations, such as inaccurate background modeling results and poor robustness against noise. To alleviate these issues, in this paper, we propose a new IPT model (dubbed as IPT-TCTV) by fully exploiting prior background knowledge. We construct an improved spatial-temporal (STT) model by sliding a 3-D window, which could better preserve the spatial correlation and temporal continuity of multiframe infrared images in the constructed tensor. Specifically, a joint low-rank and local smoothness regularization, i.e., tensor correlated total variation (TCTV), is utilized to characterize the background since the background exhibits not only the low-rank property but also the local smoothness property, without introducing additional trade-off parameters. Furthermore, considering the effect of edge structures, the _l2,1_ norm is adopted as a noise constraint to eliminate strong residuals, which can help to extract real targets from the background with more precision. Finally, we design an efficient alternating direction method of multipliers (ADMM) approach to solve the proposed model. Experimental results on some benchmark datasets illustrate that our IPT-TCTV model can achieve better detection performance than other state-of-the-art methods in various real scenes.*
<hr />

## 1. Overall Framework
![3DSWSTT_model_00](https://github.com/user-attachments/assets/15f6a927-7bce-4c3b-a1f2-539a75004c80)

Illustration. (a) The input infrared images. (b) The 3-D sliding window spatial-temporal tensor (3DSWSTT) model. _Step1_: The input images are extended by padding the edges. _Step2_: A series of stereo patch tensors are obtained by sliding a 3-D window from left to right and top to bottom. _Step3_: The spatial-temporal patch tensor $\mathcal{O}$ is constructed by collecting the centered patch tensor and its 3 × 3 adjacent patch tensors as neighborhoods. (c) The TCTV model. The constructed patch tensor $\mathcal{O}$ is separated into three modules including the background $\mathcal{B}$, the target $\mathcal{T}$ and the noise $\mathcal{N}$ patch tensors by TCTV model and solved iteratively by ADMM approach, detailed in Algorithm 1. (d) The detected background and target images are produced by tensor reconstructions.

## 2. Datasets

The ATR dataset is used to evaluate the performance of compared algorithms. The MSISTD dataset is used to perform the generalization experiment on the two compared DL methods.

[_**ATR**_](http://www.sciencedb.cn/dataSet/handle/902)

The ATR dataset, which is also known as the ground/air background infrared detection and tracking dataset, was collected and released publicly by the ATR Key Laboratory of the National University of Defense Technology between 2017 and 2019. The ATR dataset contains 22 image sequences, 16177 frames, 16944 targets, and 30 trajectories. Furthermore, each image sequence corresponds to a label file in which each target is tagged with a label location in the associated image. All images are acquired by using medium-wave (3~5um) infrared imaging equipment in specifically designed experiments, and the resolution of each infrared image is 256×256 pixels. 

<img src="https://github.com/user-attachments/assets/91313a45-7c34-4f72-8fcf-4b621bcd96b6" width="19.5%"/> <img src="https://github.com/user-attachments/assets/375ff992-75e0-4f9a-bcce-9f555d837ed1" width="19.5%"/> <img src="https://github.com/user-attachments/assets/03ac221d-4f76-45bd-bd11-e6d66dd35f66" width="19.5%"/> <img src="https://github.com/user-attachments/assets/1efe7da0-1f4f-4aa4-a60d-c2f344654c61" width="19.5%"/> <img src="https://github.com/user-attachments/assets/ea8eb38b-6141-4952-b997-162f10105b16" width="19.5%"/>

[_**MSISTD**_](https://github.com/Crescent-Ao/MSISTD)

The MSISTD dataset, which was publicly released in 2022, is a multiscene and single-frame infrared small target dataset. It contains 1,077 images and 1,343 instances, which are 2.4 times and 2.5 times more than those contained in the largest existing real-world SIRST benchmarks, respectively. This dataset extends the scale of the original SIRST dataset from 427 to 1077 with high-quality annotations, which effectively solves the lack of quantity and diversity in infrared small target detection datasets.

<img src="https://github.com/user-attachments/assets/84e91a1e-3bfa-465a-aee4-8f203a60567d" width="19.5%"/>
<img src="https://github.com/user-attachments/assets/a25ee459-19d9-4606-b7c0-d1dd3b385275" width="19.5%"/>
<img src="https://github.com/user-attachments/assets/ee2b52ae-0913-4228-a688-48e82b751c0f" width="19.5%"/>
<img src="https://github.com/user-attachments/assets/fca148f6-17c5-4bbf-bb4a-f4d8b2b0fad0" width="19.5%"/>
<img src="https://github.com/user-attachments/assets/aa2c6eab-4a3a-4bfb-9124-1c9472be72a0" width="19.5%"/>

## 4. Compared Methods
_**Single-frame methods**_

PSTNN [[Paper]](https://www.mdpi.com/2072-4292/11/4/382) [[Code]](https://github.com/Lanneeee/Infrared-Small-Target-Detection-based-on-PSTNN) WSLCM [[Paper]](https://ieeexplore.ieee.org/abstract/document/9130832) [[Code]](https://github.com/moradisaed/WSLCM) NTFRA [[Paper]](https://ieeexplore.ieee.org/abstract/document/9394596) [[Code]](https://github.com/Electromagnetism-dog-technology/Infrared-Small-Target-Detection-via-Nonconvex-Tensor-Fibered-Rank-Approximation) 

_**Multiframe methods**_

ECASTT [[Paper]](https://ieeexplore.ieee.org/abstract/document/9279305) [[Code]](https://github.com/ELOESZHANG/ECA-STT-for-IR-small-target-detection) MSLSTIPT [[Paper]](https://ieeexplore.ieee.org/abstract/document/9203993) [[Code]](https://github.com/yangsunNUDT/MSLSTIPT-V2) ASTTV-NTLA [[Paper]](https://ieeexplore.ieee.org/abstract/document/9626011) [[Code]](https://github.com/LiuTing20a/ASTTV-NTLA) IMNN-LWEC [[Paper]](https://ieeexplore.ieee.org/abstract/document/9991168) [[Code]](https://github.com/Andro-svg/IMNN-LWEC) MFSTPT [[Paper]](https://www.mdpi.com/2072-4292/14/9/2234) [[Code]](https://github.com/myp1229896165/MFSTPT) 


_**Deep learning methods**_

UIU-Net [[Paper]](https://ieeexplore.ieee.org/document/9989433) [[Code]](https://github.com/danfenghong/IEEE_TIP_UIU-Net) DNA-Net [[Paper]](https://ieeexplore.ieee.org/abstract/document/9864119) [[Code]](https://github.com/YeRen123455/Infrared-Small-Target-Detection) 

## 5. Run the code

Get started run ``main.m``

## 6. Connections

<a href="liupei3698@163.com">liupei3698@163.com</a> 











