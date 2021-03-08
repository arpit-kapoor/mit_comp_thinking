### A Pluto.jl notebook ###
# v0.12.21

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ f7779d6c-7d05-11eb-3eec-67b835a31d49
using PlutoUI

# ╔═╡ 2dda78ec-7cfb-11eb-1074-dff586b8e8fa
url = "https://i.imgur.com/u4qSjQL.jpg"

# ╔═╡ d86324e4-7cfb-11eb-1e00-05df49072f97
filename = "kitty.jpg"

# ╔═╡ bf4a3b46-7cfb-11eb-2877-2d170d568ae1
begin
	using Images
	kitty = load(filename)
end

# ╔═╡ ae3b8396-7cfb-11eb-2dff-872f229e27a2
download(url, filename)

# ╔═╡ ef55e948-7cfb-11eb-20a9-6de21b521b05
import Pkg

# ╔═╡ 3a3d8572-7d00-11eb-3392-53e53635330c
typeof(kitty)

# ╔═╡ 94b09182-7d00-11eb-0306-0397ce88520f
RGBX(0.4, 0.85, 0.8)

# ╔═╡ cb66bbfa-7d00-11eb-11a2-e7586a9bfd0e
size(kitty)

# ╔═╡ dc260204-7d00-11eb-0dc2-a3e71110ca6c
head = kitty[150:600, 300:750]

# ╔═╡ 5a7b1768-7d01-11eb-2247-1bd5bc3dd46c
[head, head]

# ╔═╡ 8ddb20ce-7d01-11eb-3073-654e6963bc9f
[
	head                  reverse(head, dims=2)
	reverse(head, dims=1) reverse(reverse(head, dims=1), dims=2)
]

# ╔═╡ dc6bb23a-7d01-11eb-352b-1711f768a5c8
[head, reverse(head, dims=2)]

# ╔═╡ 3f8cfc16-7d02-11eb-07bf-676b4231de11
md"""
# Manipulate Images
"""

# ╔═╡ 5ebd5cae-7d02-11eb-0ded-2b589e604767
new_kitty = copy(head)

# ╔═╡ a1e6937c-7d02-11eb-2c12-9f56959140b1
red = RGB(0.8, 0.2, 0.2)

# ╔═╡ ca77ad30-7d02-11eb-2d30-0b6b0ac970d3
for i in 1:100
	for j in 1:300
		new_kitty[i, j] = red
	end
end

# ╔═╡ ec715efe-7d02-11eb-0c53-13604394c4fe
new_kitty

# ╔═╡ f482fa12-7d02-11eb-3a10-35dbb05435b1
begin
	new_kitty2 = copy(head)
	new_kitty2[50:100, 1:100] .= RGB(0, 1, 0)
	new_kitty2
end

# ╔═╡ 6d485c78-7d03-11eb-177f-d7055ffc6a44
function redify(color)
	return RGB(color.r, 0.2, 0.3)
end

# ╔═╡ 82df3a94-7d03-11eb-1449-95e5ac3fa00f
begin 
	color = RGB(0.9, 0.7, 0.2)
	[color, redify(color)]
end

# ╔═╡ 879de9f6-7d03-11eb-3063-d1d157bce70f
redify.(kitty)

# ╔═╡ 785daa16-7d04-11eb-0f89-99d80e4a975f
decimate(image, ratio=5) = image[1:ratio:end, 1:ratio:end]

# ╔═╡ 87888fe8-7d03-11eb-1c60-d90fc10f6a15
begin
	poor_kitty = decimate(redify.(new_kitty2), 2)
	size(poor_kitty)
	poor_kitty
end

# ╔═╡ 87587e5c-7d03-11eb-17c5-c90b700784d6
blur(size) = ones((size, size))/(size*size)

# ╔═╡ 876c9522-7d03-11eb-00a2-556c7eeaa6ae
convolve(poor_kitty, blur(2))

# ╔═╡ 873c47f0-7d03-11eb-36a1-f304df99adb5
blur(10)

# ╔═╡ dd78ad96-7d05-11eb-0467-691a4bba5ab7
@bind blur_factor Slider(1:20, show_value=true)

# ╔═╡ Cell order:
# ╠═2dda78ec-7cfb-11eb-1074-dff586b8e8fa
# ╠═d86324e4-7cfb-11eb-1e00-05df49072f97
# ╠═ae3b8396-7cfb-11eb-2dff-872f229e27a2
# ╠═ef55e948-7cfb-11eb-20a9-6de21b521b05
# ╠═bf4a3b46-7cfb-11eb-2877-2d170d568ae1
# ╠═3a3d8572-7d00-11eb-3392-53e53635330c
# ╠═94b09182-7d00-11eb-0306-0397ce88520f
# ╠═cb66bbfa-7d00-11eb-11a2-e7586a9bfd0e
# ╠═dc260204-7d00-11eb-0dc2-a3e71110ca6c
# ╠═5a7b1768-7d01-11eb-2247-1bd5bc3dd46c
# ╠═8ddb20ce-7d01-11eb-3073-654e6963bc9f
# ╠═dc6bb23a-7d01-11eb-352b-1711f768a5c8
# ╟─3f8cfc16-7d02-11eb-07bf-676b4231de11
# ╠═5ebd5cae-7d02-11eb-0ded-2b589e604767
# ╠═a1e6937c-7d02-11eb-2c12-9f56959140b1
# ╠═ca77ad30-7d02-11eb-2d30-0b6b0ac970d3
# ╠═ec715efe-7d02-11eb-0c53-13604394c4fe
# ╠═f482fa12-7d02-11eb-3a10-35dbb05435b1
# ╠═6d485c78-7d03-11eb-177f-d7055ffc6a44
# ╠═82df3a94-7d03-11eb-1449-95e5ac3fa00f
# ╠═879de9f6-7d03-11eb-3063-d1d157bce70f
# ╠═87888fe8-7d03-11eb-1c60-d90fc10f6a15
# ╠═785daa16-7d04-11eb-0f89-99d80e4a975f
# ╠═876c9522-7d03-11eb-00a2-556c7eeaa6ae
# ╠═87587e5c-7d03-11eb-17c5-c90b700784d6
# ╠═873c47f0-7d03-11eb-36a1-f304df99adb5
# ╠═f7779d6c-7d05-11eb-3eec-67b835a31d49
# ╠═dd78ad96-7d05-11eb-0467-691a4bba5ab7
