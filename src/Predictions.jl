"""
```optimalset(dg::DiGraph{T}, set::Vector{T}) where {T<:Int}```

Look for all the maximal elements of the DiGraph `dg` in `set`.
Return the set of all maximal elements.

# Arguments

- `dg`, a DiGraph;
- `set`, a set of the same type than the DiGraph.
"""
function optimalset(dg::DiGraph{T}, set::Vector{T}) where {T<:Int}
    result = Vector{T}()
    for t in set
        copyset = copy(set)
        s = pop!(copyset)
        while !has_edge(dg, s, t) & !isempty(copyset)
            s = pop!(copyset)
        end
        if isempty(copyset) & !has_edge(dg, s, t)
            push!(result, t)
        end
    end
    return result
end


"""
```Selten(cc::Union{ChoiceFunction{T}, ChoiceCorrespondence{T}}, dg::DiGraph{T}, cset::Vector{T}, pset::Vector{T}) where T<:Int```

Compute the Selten's score of a given digraph and a given choice correspondence on a given set.

# Arguments

- `cc`, a ChoiceFunction or a ChoiceCorrespondence;
- `dg`, a DiGraph, normally derived from `cc`;
- `set`, the set on which we are looking for predictions.
"""
function Selten(cc::Union{ChoiceFunction{T}, ChoiceCorrespondence{T}}, dg::DiGraph{T}, set::Vector{T}) where T<:Int
    if typeof(cc) <: ChoiceFunction
        return in(cc[set], set) - length(optimalset(dg, set)) / length(set)
    else
        return issubset(cc, set) - length(optimalset(dg, set)) / length(set)
    end
end




"""
```Selten(cc::Union{ChoiceCorrespondence{T}, ChoiceFunction{T}}, dg::DiGraph{T}, sets::Vector{Vector{T}}, f = mean) where T<:Int```

Aggregate Selten's score of a given digraph on a given ChoiceFunction or ChoiceCorrespondence for a list of sets, according to function f.

# Arguments

- `dg`, a DiGraph;
- `set`, a vector of sets of the same type than the DiGraph;
- `f`, a function to use for aggregation, default the mean.
"""
function Selten(cc::Union{ChoiceCorrespondence{T}, ChoiceFunction{T}}, dg::DiGraph{T}, sets::Vector{Vector{T}}, f = mean) where T <: Int
    res = Vector{Float64}()
    for set in sets
        push!(res, Selten(cc, dg, set))
    end
    return f(res)
end