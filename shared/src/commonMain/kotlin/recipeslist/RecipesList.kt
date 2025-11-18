package recipeslist

import androidx.compose.animation.AnimatedVisibilityScope
import androidx.compose.animation.ExperimentalSharedTransitionApi
import androidx.compose.animation.SharedTransitionScope
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.grid.GridCells
import androidx.compose.foundation.lazy.grid.LazyGridState
import androidx.compose.foundation.lazy.grid.LazyVerticalGrid
import androidx.compose.foundation.lazy.grid.rememberLazyGridState
import androidx.compose.material.Button
import androidx.compose.material.Text
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import model.Recipe
import sugar


/**
 * Created by abdulbasit on 25/06/2023.
 */

@OptIn(ExperimentalSharedTransitionApi::class)
@Composable
fun RecipesListScreen(
    items: List<Recipe>,
    onClick: (recipe: Recipe) -> Unit,
    onSimulateEmptyFeed: () -> Unit,
    isLarge: Boolean,
    sharedTransactionScope: SharedTransitionScope,
    animatedVisibilityScope: AnimatedVisibilityScope,
) {
    Box(
        modifier = Modifier.fillMaxSize().background(sugar)
    ) {
        Column(modifier = Modifier.fillMaxSize()) {
            Button(
                onClick = onSimulateEmptyFeed,
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(horizontal = 16.dp, vertical = 8.dp)
            ) {
                Text("Simulate empty feed")
            }

            val listState = rememberLazyGridState()
            LazyVerticalGrid(
                state = listState, columns = GridCells.Fixed(if (isLarge) 3 else 1)
            ) {
                if (isLarge.not())
                    item {
                        Spacer(modifier = Modifier.windowInsetsPadding(WindowInsets.systemBars))
                    }
                items(items.size) { item ->
                    val recipe = items[item]
                    RecipeListItemWrapper(
                        scrollDirection = listState.isScrollingUp(),
                        child = {
                            RecipeListItem(
                                recipe = recipe,
                                onClick = onClick,
                                sharedTransitionScope = sharedTransactionScope,
                                animatedVisibilityScope = animatedVisibilityScope,
                            )
                        }
                    )
                }
            }
        }
    }
}

@Composable
private fun LazyGridState.isScrollingUp(): Boolean {
    var previousIndex by remember(this) { mutableStateOf(firstVisibleItemIndex) }
    var previousScrollOffset by remember(this) { mutableStateOf(firstVisibleItemScrollOffset) }
    return remember(this) {
        derivedStateOf {
            if (previousIndex != firstVisibleItemIndex) {
                previousIndex > firstVisibleItemIndex
            } else {
                previousScrollOffset >= firstVisibleItemScrollOffset
            }.also {
                previousIndex = firstVisibleItemIndex
                previousScrollOffset = firstVisibleItemScrollOffset
            }
        }
    }.value
}