### A Pluto.jl notebook ###
# v0.12.21

using Markdown
using InteractiveUtils

# ╔═╡ b66e48de-7d28-11eb-19ce-f58769e9d628
begin
	using Markdown
	using InteractiveUtils
end

# ╔═╡ 52cb55ee-7d24-11eb-3a8e-1378dceb2b15
begin
	using FFTW
	using Plots
	using DSP
	using ImageFiltering
	using PlutoUI
end

# ╔═╡ 8550abaa-7d23-11eb-2cb6-59b12afebcc1
function shrink_image(image, ratio=5)
	(height, width) = size(image)
	new_height = height ÷ ratio - 1
	new_width = width ÷ ratio - 1
	list = [
		mean(image[
			ratio * i:ratio * (i + 1),
			ratio * j:ratio * (j + 1),
		])
		for j in 1:new_width
		for i in 1:new_height
	]
	reshape(list, new_height, new_width)
end

# ╔═╡ 44d69d1c-7d23-11eb-195b-33e17be706ca
begin
	large_image = load("kitty.jpg")
	image = shrink_image(large_image, 3)
end

# ╔═╡ 07bdaae8-7d24-11eb-1c5b-fb6dd92cc0cb
size(image)

# ╔═╡ 17f4d91c-7d2a-11eb-0360-535a27e6b247
blur_kernel = Kernel.gaussian((15, 15))

# ╔═╡ 1bad75b6-7d2d-11eb-0ba2-a1ebf99a33ed
sobel_kernel = Kernel.sobel()[2]

# ╔═╡ 61ddf862-7d2d-11eb-38eb-b95c60f4dce1
sum(sobel_kernel)

# ╔═╡ 88168c0e-7d2a-11eb-0c84-ff627867378a
function show_colored_kernel(kernel)
	to_rgb(x) = RGB(max(-x, 0), max(x, 0), 0)
	to_rgb.(kernel) / maximum(abs.(kernel))
end

# ╔═╡ cee11822-7d2a-11eb-3b7f-39843d1cc8ae
show_colored_kernel(sobel_kernel)

# ╔═╡ 651a410e-7d2b-11eb-0854-e148d39911ef
function rolloff_boundary(M, i, j)
	if (1 ≤ i ≤ size(M, 1)) && (1 ≤ j ≤ size(M, 2))
		return M[i, j]
	else
		return 0 * M[1, 1]
	end
end

# ╔═╡ 6693d9c8-7d2b-11eb-254f-bdd606044ec6
function clamp_at_boundary(M, i, j)
	return M[
		clamp(i, 1, size(M, 1)),
		clamp(j, 1, size(M, 2)),	
	]
end

# ╔═╡ 2a944296-7d2b-11eb-05d4-07ff58df31e7
function convolve(M, kernel, M_index_func=clamp_at_boundary)
    height = size(kernel, 1)
    width = size(kernel, 2)
    
    half_height = height ÷ 2
    half_width = width ÷ 2
    
    new_image = similar(M)
	
    # (i, j) loop over the original image
    @inbounds for i in 1:size(M, 1)
        for j in 1:size(M, 2)
            # (k, l) loop over the neighbouring pixels
			new_image[i, j] = sum([
				kernel[k, l] * M_index_func(M, i - k, j - l)
				for k in -half_height:-half_height + height - 1
				for l in -half_width:-half_width + width - 1
			])
        end
    end
    
    return new_image
end

# ╔═╡ 05a9e3bc-7d2b-11eb-2538-f3d5c5841e9a
Gray.(abs.(convolve(image, sobel_kernel)))

# ╔═╡ 7759e374-7d2b-11eb-3dc4-416de0a6c0a8
function rgb_to_float(color)
    return mean([color.r, color.g, color.b])
end

# ╔═╡ 746cbe1e-7d2b-11eb-08a7-0f73ee11ebd2
function fourier_spectrum_magnitudes(img)
    grey_values = rgb_to_float.(img)
    spectrum = fftshift(fft(grey_values))
	return abs.(spectrum)
end

# ╔═╡ 6def2efe-7d2b-11eb-21db-85fda30d224a
function heatmap_2d_fourier_spectrum(img)
	heatmap(log.(fourier_spectrum_magnitudes(img)))
end

# ╔═╡ 7167de12-7d2b-11eb-3623-a9c2150089ae
function plot_1d_fourier_spectrum(img, dims=1)
	spectrum = fourier_spectrum_magnitudes(img)
	plot(centered(mean(spectrum, dims=1)[1:end]))
end

# ╔═╡ 3e6b5ee2-7d2b-11eb-381e-efbcaf2c8ea5
function decimate(arr, ratio=5)
	return arr[1:ratio:end, 1:ratio:end]
end

# ╔═╡ Cell order:
# ╠═b66e48de-7d28-11eb-19ce-f58769e9d628
# ╠═52cb55ee-7d24-11eb-3a8e-1378dceb2b15
# ╠═44d69d1c-7d23-11eb-195b-33e17be706ca
# ╠═8550abaa-7d23-11eb-2cb6-59b12afebcc1
# ╠═07bdaae8-7d24-11eb-1c5b-fb6dd92cc0cb
# ╠═17f4d91c-7d2a-11eb-0360-535a27e6b247
# ╠═1bad75b6-7d2d-11eb-0ba2-a1ebf99a33ed
# ╠═61ddf862-7d2d-11eb-38eb-b95c60f4dce1
# ╠═cee11822-7d2a-11eb-3b7f-39843d1cc8ae
# ╠═05a9e3bc-7d2b-11eb-2538-f3d5c5841e9a
# ╟─88168c0e-7d2a-11eb-0c84-ff627867378a
# ╟─2a944296-7d2b-11eb-05d4-07ff58df31e7
# ╟─651a410e-7d2b-11eb-0854-e148d39911ef
# ╟─6693d9c8-7d2b-11eb-254f-bdd606044ec6
# ╟─6def2efe-7d2b-11eb-21db-85fda30d224a
# ╟─7167de12-7d2b-11eb-3623-a9c2150089ae
# ╟─746cbe1e-7d2b-11eb-08a7-0f73ee11ebd2
# ╟─7759e374-7d2b-11eb-3dc4-416de0a6c0a8
# ╟─3e6b5ee2-7d2b-11eb-381e-efbcaf2c8ea5
